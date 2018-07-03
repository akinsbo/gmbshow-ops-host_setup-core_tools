old_string=$1
new_string=$2
regex_to_run="s/$old_string/$new_string/g"
blue_color="\e[34m"
yellow_color="\e[33m"
green_color="\e[32m"
white_color="\e[97m"
magenta_color="\e[95m"
echo
echo -e "$yellow_color search for string to replace"
grep -r $old_string
echo
echo -e "$blue_color Regex to run: $green_color $regex_to_run"
echo
echo -e "$white_color replacing string..."
grep -rl "$old_string" . | xargs sed -i "$regex_to_run"
# # This way is:
# grep -rl "$old_string" /dir_to_search_under | xargs sed -i "s/$old_string/$new_string/g"
# # Another way is,
# find . -type f -exec sed -i "$regex_to_run" {} \;
# # For more speed and limiting to git repo items, if in a git repo, run:
# git grep -rl "$old_string" . | xargs sed -i "s/$old_string/$new_string/g"
echo 
echo -e "$green_color search for new string"
grep -r $new_string
echo
echo -e "$yellow_color search for old string"
grep -r $old_string

# Example:
## to change the file reference to /add.yml
echo
# bash rename_var.sh "mng_config_file\/add.yml" "mng_config_file\/edit.yml" 
echo
echo -e "$white_color If you get $magenta_color'fatal: Unknown index entry format xxxxxxxxx'$white_color, just run:"
echo -e "$blue_color rm -f .git/index" # -e option of echo allows parsing of escape sequences
echo -e "$blue_color git reset"
echo 
