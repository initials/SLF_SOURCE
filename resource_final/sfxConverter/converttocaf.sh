##
## Shell script to batch convert all files in a directory to caf sound format for iPhone
## Place this shell script a directory with sound files and run it: 'sh converttocaf.sh'
## Any comments to 'support@ezone.com'
##

for f in *; do
    if  [ "$f" != "converttocaf.sh" ]
    then
        /usr/bin/afconvert -f caff -d LEI16 $f
        echo "$f converted"
    fi
done