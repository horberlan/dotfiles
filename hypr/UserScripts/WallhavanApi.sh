#!/bin/bash
# =============================================================================
# Wallhaven API Wallpaper Manager - Interface Integrada
# Script refatorado com filtros na mesma interface da listagem
# =============================================================================
set -euo pipefail
# =============================================================================
# CONFIGURAÇÕES GLOBAIS
# =============================================================================
readonly SCRIPT_NAME="Wallhaven Manager"
readonly SCRIPT_VERSION="3.0"
readonly CONFIG_DIR="$HOME/.config/wallhaven-manager"
readonly DOWNLOAD_DIR="$HOME/Pictures/wallhaven"
readonly SCRIPTSDIR="$HOME/.config/hypr/UserScripts"
readonly TEMP_DIR="/tmp/wallhaven_$$"
readonly CACHE_DIR="$CONFIG_DIR/cache"
readonly LOG_FILE="$CONFIG_DIR/wallhaven.log"
# API Configuration
readonly API_KEY=""
readonly BASE_URL="https://wallhaven.cc/api/v1"
readonly ITEMS_PER_PAGE=24
readonly CACHE_DURATION=300
# Display Configuration
readonly FPS=60
readonly TRANSITION_TYPE="any"
readonly DURATION=1.5
readonly SWWW_PARAMS="--transition-fps $FPS --transition-type $TRANSITION_TYPE --transition-duration $DURATION"
readonly ROFI_CONFIG="$HOME/.config/rofi/config-wallpaper-api.rasi"
# Estado global da aplicação
declare CURRENT_QUERY=""
declare CURRENT_CATEGORY="010" # Anime por padrão
declare CURRENT_SORTING="random"
declare CURRENT_RESOLUTION=""
declare CURRENT_PAGE=1
declare TOTAL_PAGES=1
# =============================================================================
# ESTRUTURAS DE DADOS
# =============================================================================
declare -A CATEGORIES=(
    ["🎨 General"]="100"
    ["🌸 Anime"]="010"
    ["👥 People"]="001"
    ["🌍 All"]="111"
)
declare -A SORTING_OPTIONS=(
    ["🎲 Random"]="random"
    ["📅 Newest"]="date_added"
    ["🔥 Hot"]="hot"
    ["⭐ Favorites"]="favorites"
    ["👁️ Views"]="views"
    ["🎯 Relevance"]="relevance"
)
declare -A RESOLUTIONS=(
    ["📱 Any"]=""
    ["🖥️ 1920x1080"]="1920x1080"
    ["🖥️ 2560x1440"]="2560x1440"
    ["🖥️ 4K"]="3840x2160"
    ["💻 1366x768"]="1366x768"
)
declare -A SEARCH_PRESETS=(
    ["🌸 Anime Girl"]="anime girl"
    ["🏔️ Nature"]="nature landscape mountain"
    ["🎨 Abstract"]="abstract art digital"
    ["🌃 Cityscape"]="city urban night lights"
    ["🌌 Space"]="space galaxy stars nebula"
    ["🎮 Gaming"]="gaming cyberpunk neon"
    ["🚗 Cars"]="car sports automotive"
    ["🏛️ Architecture"]="architecture building modern"
    ["🐾 Animals"]="animals wildlife cute"
    ["💻 Technology"]="technology cyberpunk futuristic"
    ["🌊 Ocean"]="ocean sea waves blue"
    ["🌺 Flowers"]="flowers botanical colorful"
)
# =============================================================================
# FUNÇÕES DE UTILIDADE
# =============================================================================
log() {
    local level="$1"
    shift
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $*" | tee -a "$LOG_FILE" >&2
}
log_info() { log "INFO" "$@"; }
log_error() { log "ERROR" "$@"; }
error_exit() {
    log_error "$1"
    notify-send "❌ Erro" "$1" 2>/dev/null || true
    cleanup
    exit 1
}
success_notify() {
    log_info "$1"
    notify-send "✅ Sucesso" "$1" 2>/dev/null || true
}
cleanup() {
    rm -rf "$TEMP_DIR" 2>/dev/null || true
    pkill -f "curl.*wallhaven" 2>/dev/null || true
}
setup_directories() {
    local dirs=("$CONFIG_DIR" "$DOWNLOAD_DIR" "$TEMP_DIR" "$CACHE_DIR")
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir" || error_exit "Falha ao criar diretório: $dir"
    done
}
get_focused_monitor() {
    hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}' 2>/dev/null || echo "DP-1"
}
# =============================================================================
# FUNÇÕES DA API
# =============================================================================
build_api_url() {
    local query="$1"
    local category="$2"
    local sorting="$3"
    local resolution="$4"
    local page="$5"
    local url="${BASE_URL}/search"
    local params=()
    [[ -n "$query" ]] && params+=("q=$(printf '%s' "$query" | sed 's/ /+/g')")
    params+=("categories=$category")
    params+=("purity=100") # Apenas SFW
    params+=("sorting=$sorting")
    params+=("order=desc")
    params+=("page=$page")
    [[ -n "$resolution" ]] && params+=("resolutions=$resolution")
    [[ -n "$API_KEY" ]] && params+=("apikey=$API_KEY")
    local query_string=$(IFS='&'; echo "${params[*]}")
    echo "${url}?${query_string}"
}
fetch_wallpapers() {
    local query="$1"
    local category="$2"
    local sorting="$3"
    local resolution="$4"
    local page="$5"
    local url=$(build_api_url "$query" "$category" "$sorting" "$resolution" "$page")
    log_info "API Request: $url"
    local response
    response=$(curl -s -f --connect-timeout 10 --max-time 30 "$url") || {
        error_exit "Falha na conexão com a API do Wallhaven. Verifique sua internet ou configurações."
    }
    [[ -z "$response" ]] && error_exit "Resposta vazia da API"
    local error_msg
    error_msg=$(echo "$response" | jq -r '.error // empty' 2>/dev/null) || {
        error_exit "Resposta inválida da API"
    }
    [[ -n "$error_msg" ]] && error_exit "Erro da API: $error_msg"
    echo "$response"
}
get_wallpaper_details() {
    local id="$1"
    local url="${BASE_URL}/w/${id}"
    [[ -n "$API_KEY" ]] && url="${url}?apikey=${API_KEY}"
    local response
    response=$(curl -s -f --connect-timeout 10 --max-time 20 "$url") || {
        error_exit "Falha ao buscar detalhes do wallpaper $id"
    }
    local error_msg
    error_msg=$(echo "$response" | jq -r '.error // empty' 2>/dev/null) || {
        error_exit "Resposta inválida para wallpaper $id"
    }
    [[ -n "$error_msg" ]] && error_exit "Erro da API: $error_msg"
    echo "$response"
}
# =============================================================================
# FUNÇÕES DE PROCESSAMENTO
# =============================================================================
create_control_items() {
    local data_file="$1"
    # Seções de filtros expandidas
    echo "━━━━━━━━━━━━━━━━━ CATEGORIAS ━━━━━━━━━━━━━━━━━" >> "$data_file"
    for cat_display in "${!CATEGORIES[@]}"; do
        local cat_code="${CATEGORIES[$cat_display]}"
        if [[ "$cat_code" == "$CURRENT_CATEGORY" ]]; then
            echo "$cat_display [ATIVA]" >> "$data_file"
        else
            echo "$cat_display" >> "$data_file"
        fi
    done
    echo "━━━━━━━━━━━━━━━━━ ORDENAÇÃO ━━━━━━━━━━━━━━━━━" >> "$data_file"
    for sort_display in "${!SORTING_OPTIONS[@]}"; do
        local sort_code="${SORTING_OPTIONS[$sort_display]}"
        if [[ "$sort_code" == "$CURRENT_SORTING" ]]; then
            echo "$sort_display [ATIVA]" >> "$data_file"
        else
            echo "$sort_display" >> "$data_file"
        fi
    done
    echo "━━━━━━━━━━━━━━━━━ RESOLUÇÕES ━━━━━━━━━━━━━━━━━" >> "$data_file"
    for res_display in "${!RESOLUTIONS[@]}"; do
        local res_code="${RESOLUTIONS[$res_display]}"
        if [[ "$res_code" == "$CURRENT_RESOLUTION" ]]; then
            echo "$res_display [ATIVA]" >> "$data_file"
        else
            echo "$res_display" >> "$data_file"
        fi
    done
    echo "━━━━━━━━━━━━━━━━━ PRESETS ━━━━━━━━━━━━━━━━━" >> "$data_file"
    for preset_display in "${!SEARCH_PRESETS[@]}"; do
        echo "$preset_display" >> "$data_file"
    done
    echo "━━━━━━━━━━━━━━━━━ PAGINAÇÃO ━━━━━━━━━━━━━━━━━" >> "$data_file"
    # Paginação
    if [[ $CURRENT_PAGE -gt 1 ]]; then
        echo "⬅️ PÁGINA ANTERIOR ($((CURRENT_PAGE - 1))/$TOTAL_PAGES)" >> "$data_file"
    fi
    if [[ $CURRENT_PAGE -lt $TOTAL_PAGES ]]; then
        echo "➡️ PRÓXIMA PÁGINA ($((CURRENT_PAGE + 1))/$TOTAL_PAGES)" >> "$data_file"
    fi
    # Separador para wallpapers
    echo "━━━━━━━━━━━━━━━━━ WALLPAPERS ━━━━━━━━━━━━━━━━━" >> "$data_file"
}
download_thumbnails() {
    local response="$1"
    local thumb_dir="$2"
    local data_file="$3"
    # Adiciona controles no topo
    create_control_items "$data_file"
    log_info "Baixando previews..."
    local count=0
    local total
    total=$(echo "$response" | jq '.data | length')
    TOTAL_PAGES=$(echo "$response" | jq -r '.meta.last_page // 1')
    while IFS= read -r line; do
        local id resolution category colors thumb_url
        id=$(echo "$line" | jq -r '.id')
        resolution=$(echo "$line" | jq -r '.resolution')
        category=$(echo "$line" | jq -r '.category')
        colors=$(echo "$line" | jq -r '.colors[0] // "N/A"')
        thumb_url=$(echo "$line" | jq -r '.thumbs.small')
        [[ "$id" == "null" || -z "$id" ]] && continue
        count=$((count + 1))
        printf "\rBaixando preview %d/%d..." "$count" "$total" >&2
        local thumb_file="$thumb_dir/$id.jpg"
        local display_text="$id • $resolution • $category • $colors"
        if curl -s -f --connect-timeout 5 --max-time 15 "$thumb_url" -o "$thumb_file" && [[ -s "$thumb_file" ]]; then
            printf '%s\x00icon\x1f%s\n' "$display_text" "$thumb_file" >> "$data_file"
        else
            printf '%s\n' "$display_text" >> "$data_file"
            rm -f "$thumb_file" 2>/dev/null || true
        fi
    done < <(echo "$response" | jq -c '.data[]')
    echo >&2
    log_info "Processados $count wallpapers (Página $CURRENT_PAGE/$TOTAL_PAGES)"
}
show_integrated_interface() {
    local data_file="$1"
    [[ ! -s "$data_file" ]] && error_exit "Nenhum wallpaper encontrado"
    pkill rofi 2>/dev/null || true
    sleep 0.3
    local query_display="${CURRENT_QUERY:-"Busca inicial"}"
    local prompt="🎞️ $query_display (Pág $CURRENT_PAGE/$TOTAL_PAGES)"
    cat "$data_file" | rofi -dmenu -i -p "$prompt" \
        -config "$ROFI_CONFIG" \
        -markup-rows \
        -kb-custom-1 "Alt+Return" \
        -kb-custom-2 "Alt+r" \
        -kb-custom-3 "Alt+n" \
        2>/dev/null || true
}
# =============================================================================
# FUNÇÕES DE INTERFACE
# =============================================================================
handle_filter_selection() {
    local selected="$1"
    local selected_clean
    selected_clean=$(echo "$selected" | sed 's/ \[ATIVA\]//')
    if [[ -n "${CATEGORIES[$selected_clean]}" ]]; then
        CURRENT_CATEGORY="${CATEGORIES[$selected_clean]}"
        CURRENT_PAGE=1
        return 0
    elif [[ -n "${SORTING_OPTIONS[$selected_clean]}" ]]; then
        CURRENT_SORTING="${SORTING_OPTIONS[$selected_clean]}"
        CURRENT_PAGE=1
        return 0
    elif [[ -n "${RESOLUTIONS[$selected_clean]}" ]]; then
        CURRENT_RESOLUTION="${RESOLUTIONS[$selected_clean]}"
        CURRENT_PAGE=1
        return 0
    elif [[ -n "${SEARCH_PRESETS[$selected_clean]}" ]]; then
        CURRENT_QUERY="${SEARCH_PRESETS[$selected_clean]}"
        CURRENT_PAGE=1
        return 0
    elif [[ "$selected" == "⬅️ PÁGINA ANTERIOR"* ]]; then
        [[ $CURRENT_PAGE -gt 1 ]] && ((CURRENT_PAGE--))
        return 0
    elif [[ "$selected" == "➡️ PRÓXIMA PÁGINA"* ]]; then
        [[ $CURRENT_PAGE -lt $TOTAL_PAGES ]] && ((CURRENT_PAGE++))
        return 0
    fi
    return 1
}
# =============================================================================
# FUNÇÕES DE APLICAÇÃO
# =============================================================================
apply_wallpaper() {
    local image="$1"
    local focused_monitor
    focused_monitor=$(get_focused_monitor)
    log_info "Aplicando wallpaper: $(basename "$image")"
    # Aplicar wallpaper
    swww img -o "$focused_monitor" "$image" $SWWW_PARAMS || {
        log_error "Falha ao aplicar wallpaper"
        return 1
    }
    # Symlink
    mkdir -p "$HOME/.config/rofi"
    ln -sf "$image" "$HOME/.config/rofi/.current_wallpaper"
}
download_and_apply_wallpaper() {
    local wallpaper_id="$1"
    log_info "Obtendo detalhes do wallpaper: $wallpaper_id"
    local details
    details=$(get_wallpaper_details "$wallpaper_id")
    local image_url
    image_url=$(echo "$details" | jq -r '.data.path')
    [[ -z "$image_url" || "$image_url" == "null" ]] && {
        error_exit "URL da imagem não encontrada para ID: $wallpaper_id"
    }
    local extension="${image_url##*.}"
    local image_file="$DOWNLOAD_DIR/${wallpaper_id}.${extension}"
    log_info "Baixando wallpaper completo..."
    curl -s -f --connect-timeout 10 --max-time 60 "$image_url" -o "$image_file" || {
        error_exit "Falha ao baixar o wallpaper"
    }
    [[ ! -s "$image_file" ]] && error_exit "Arquivo baixado está vazio"
    apply_wallpaper "$image_file"
    success_notify "Wallpaper aplicado com sucesso! ID: $wallpaper_id"
}
# =============================================================================
# FUNÇÃO PRINCIPAL
# =============================================================================
main_loop() {
    while true; do
        log_info "Buscando wallpapers: '$CURRENT_QUERY' | Página: $CURRENT_PAGE"
        local response
        response=$(fetch_wallpapers "$CURRENT_QUERY" "$CURRENT_CATEGORY" "$CURRENT_SORTING" "$CURRENT_RESOLUTION" "$CURRENT_PAGE")
        local total
        total=$(echo "$response" | jq -r '.meta.total // 0')
        if [[ "$total" -eq 0 ]]; then
            notify-send "⚠️ Aviso" "Nenhum wallpaper encontrado para: '$CURRENT_QUERY'"
            CURRENT_QUERY=""
            continue
        fi
        local thumb_dir="$TEMP_DIR/thumbs"
        local data_file="$TEMP_DIR/wallpapers.txt"
        mkdir -p "$thumb_dir"
        > "$data_file" # Limpa o arquivo
        download_thumbnails "$response" "$thumb_dir" "$data_file"
        local selected
        selected=$(show_integrated_interface "$data_file")
        [[ -z "$selected" ]] && break
        # Verifica se é um controle
        if handle_filter_selection "$selected"; then
            continue # Recarrega interface com novos filtros
        fi
        # Se chegou aqui, verifica se é wallpaper ou busca customizada
        if [[ "$selected" == *"•"* ]]; then
            # Extrai ID do wallpaper (formato: "ID • resolution • category • color")
            local wallpaper_id
            wallpaper_id=$(echo "$selected" | cut -d'•' -f1 | xargs)
            if [[ -n "$wallpaper_id" && "$wallpaper_id" =~ ^[a-z0-9]+$ ]]; then
                download_and_apply_wallpaper "$wallpaper_id"
                break
            fi
        else
            # Busca customizada digitada diretamente
            if [[ -n "$selected" && ! "$selected" =~ ━ ]]; then
                CURRENT_QUERY="$selected"
                CURRENT_PAGE=1
                continue
            fi
        fi
    done
}
main() {
    trap cleanup EXIT INT TERM
    log_info "=== Iniciando $SCRIPT_NAME v$SCRIPT_VERSION ==="
    setup_directories

    CURRENT_QUERY="general"
    CURRENT_PAGE=1
    main_loop
    log_info "Finalizando $SCRIPT_NAME"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi