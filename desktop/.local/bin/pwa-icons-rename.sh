#!/usr/bin/env bash
# ==============================================================================
# PROBLEM:
# Under Wayland, Chromium-based browsers identify PWA windows using generic
# browser class names. When an icon theme contains icons for these browsers,
# KDE Plasma uses the theme's icon instead of the unique PWA icon.
#
# RATIONALE:
# This script forces a fallback to the correct PWA icons by hiding the
# generic browser icons within all local icon themes in ~/.local/share/icons/.
#
# TARGETED BROWSER ICONS:
# - Google Chrome, Chromium, Ungoogled Chromium, Brave, Vivaldi, Opera,
# Microsoft Edge, Thorium, Iridium, Arc (Linux), Floorp (Chromium-based),
# Naver Whale, and Epic Privacy Browser.
# ==============================================================================

# Set color codes for output
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
ORANGE=$(tput setaf 208)
BOLD=$(tput bold)
NC=$(tput sgr0) # No or reset color

echo "${CYAN}${BOLD}== PWA ICONS RENAME UTILITY ==${NC}"
echo "This script will scan ${YELLOW}~/.local/share/icons/${NC} and rename generic"
echo "browser icons to ${GREEN}.bak${NC} to prevent them from hijacking PWA windows."

selected_browsers=""

add_selection() {
  case " $selected_browsers " in
    *" $1 "*) ;;
    *) selected_browsers="$selected_browsers $1" ;;
  esac
}

is_selected() {
  case " $selected_browsers " in
    *" $1 "*) return 0 ;;
  esac

  return 1
}

show_menu() {
  echo ""
  echo "Select browser groups to hide from the icon theme:"
  echo " ${ORANGE} 1${NC}) Google Chrome"
  echo " ${ORANGE} 2${NC}) Chromium / Ungoogled Chromium"
  echo " ${ORANGE} 3${NC}) Brave"
  echo " ${ORANGE} 4${NC}) Vivaldi"
  echo " ${ORANGE} 5${NC}) Opera"
  echo " ${ORANGE} 6${NC}) Microsoft Edge"
  echo " ${ORANGE} 7${NC}) Thorium"
  echo " ${ORANGE} 8${NC}) Iridium"
  echo " ${ORANGE} 9${NC}) Arc"
  echo " ${ORANGE}10${NC}) Floorp"
  echo " ${ORANGE}11${NC}) Naver Whale"
  echo " ${ORANGE}12${NC}) Epic Privacy Browser"
  echo " ${ORANGE} A${NC}) ${CYAN}All${NC}"
  echo " ${ORANGE} Q${NC}) ${YELLOW}Quit${NC}"
  echo ""
  echo "Enter one or more choices separated by spaces or commas (e.g., ${YELLOW}1,3 5${NC}) [${YELLOW}All${NC}]: "
}

show_menu
read -r selection_input
selection_input=${selection_input,,}
selection_input=${selection_input:-a}
selection_input=$(printf '%s' "$selection_input" | tr ',' ' ')

case " $selection_input " in
  *" q "*|*" Q "*)
    echo "${ORANGE}⚠${NC} Operation cancelled."
    exit 0
    ;;
esac

for selection in $selection_input; do
  case "$selection" in
    1|chrome) add_selection chrome ;;
    2|chromium) add_selection chromium ;;
    3|brave) add_selection brave ;;
    4|vivaldi) add_selection vivaldi ;;
    5|opera) add_selection opera ;;
    6|edge|microsoft-edge) add_selection edge ;;
    7|thorium) add_selection thorium ;;
    8|iridium) add_selection iridium ;;
    9|arc) add_selection arc ;;
    10|floorp) add_selection floorp ;;
    11|whale) add_selection whale ;;
    12|epic) add_selection epic ;;
    13|a|all)
      selected_browsers=" chrome chromium brave vivaldi opera edge thorium iridium arc floorp whale epic "
      break
      ;;
    *)
      echo "${RED}✗${NC} Unknown selection: $selection"
      exit 1
      ;;
  esac
done

echo "Renaming selected browser assets..."
find ~/.local/share/icons/ -type f \
  -not -path "*/hicolor/*" \
  -not -name "*.bak" | while IFS= read -r file; do
  case "$file" in
    *chrome*|*chromium*) is_selected chrome || is_selected chromium || continue ;;
    *brave*) is_selected brave || continue ;;
    *vivaldi*) is_selected vivaldi || continue ;;
    *opera*) is_selected opera || continue ;;
    *microsoft-edge*) is_selected edge || continue ;;
    *thorium*) is_selected thorium || continue ;;
    *iridium*) is_selected iridium || continue ;;
    *arc*) is_selected arc || continue ;;
    *floorp*) is_selected floorp || continue ;;
    *whale*) is_selected whale || continue ;;
    *epic*) is_selected epic || continue ;;
    *)
      continue
      ;;
  esac

  mv "$file" "${file}.bak"
done

echo "Rebuilding KDE icon database..."
kbuildsycoca6 2>/dev/null

echo ""
echo "${RED}CRITICAL STEP${NC}: Plasma Shell Restart Required."
echo "--------------------------------------------------------------------------"
echo "To display the new icons, the Plasma desktop shell must be refreshed."
echo "${ORANGE}⚠ WARNING${NC}: Your desktop, panels, and wallpaper will temporarily disappear."
echo "--------------------------------------------------------------------------"

echo "Restart Plasma shell now? (y/n) [${YELLOW}Y${NC}]: "
read -r confirm_plasma

if [ "$confirm_plasma" = "y" ] || [ "$confirm_plasma" = "Y" ] || [ "$confirm_plasma" = "" ]; then
  echo "Restarting plasmashell... please wait."
  plasmashell --replace >/dev/null 2>&1 & disown
  echo "${GREEN}✔${NC} Icons modified and Plasma shell refreshed."
else
  echo "${GREEN}✔${NC} Icons modified. Changes will take effect after your next login."
fi
