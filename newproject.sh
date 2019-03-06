# usage:
# newproject <name>

templatemenu ()
{
  echo "Choose source template"
  select option; do
    if [ 1 -le "$REPLY" ] && [ "$REPLY" -le $(($#)) ];
    then
      printf "Instancing \e[1m$option\e[m\n"
      break;
    else
      echo "Incorrect Input: Select a number 1-$#"
    fi
  done
}

devdir=/Library/WebServer/Documents/projects/
repourl=https://github.com/f4kill/templates/trunk/stencils/
templates=()
while IFS= read -r line; do
		templates+=( "$line" )
done < <( svn list $repourl | egrep '/$' )

templatemenu "${templates[@]}"


if [ -z $1 ]; then
	printf "Project name ? "
	read name
else
	name=$1
fi

svn export -q $repourl$option $devdir$name
printf "Created \e[1m$name\e[m project from template \e[1m$option\e[m at \e[1m$devdir$name\e[m\n"
open $devdir$name