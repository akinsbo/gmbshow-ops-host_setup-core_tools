old_string=$1
new_string=$2
regex_to_run="s/$old_string/$new_string/g"
echo
echo 'search for string to replace'
grep -r $old_string
echo
echo "Regex to run: $regex_to_run"
echo
echo 'replacing string'
find . -type f -exec sed -i "$regex_to_run" {} \;
# # Another and probably faster way is:
# grep -rl "$old_string" /dir_to_search_under | xargs sed -i "s/$old_string/$new_string/g"
# # For our case,
# grep -rl "$old_string" . | xargs sed -i "s/$old_string/$new_string/g"
# # For more speed and limiting to git repo items, if in a git repo, run:
# git grep -rl "$old_string" . | xargs sed -i "s/$old_string/$new_string/g"
echo 
echo 'search for new string'
grep -r $new_string
echo
echo 'search for old string'
grep -r $old_string
