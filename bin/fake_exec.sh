#!/bin/ksh
#Auteur : Erwan SEITE
#Licence : GPLv3
#Source : https://github.com/wanix/ScriptsEnVrac/blob/master/bin/fake_exec.sh

#Ce script simule un EXE quelconque et eventuellement son comportement.
#Soit myScriptName le nom donne a ce script (via un lien symbolique)
#Si le fichier /TMP/myScriptName.content existe (et est lisible), alors la reponse de ce script sera le contenu de ce fichier par STDOUT.
#Si le fichier /TMP/myScriptName.content n'existe pas, alors le script sort sur la sortie standard :
#  - Son appel et ses parametres
#  - eventuellement ce qui lui est passe par STDIN
#Si le fichier /TMP/myScriptName.return existe et est lisible, alors le code retour de ce script sera :
# - le resultat de $(head -n 1 | xargs expr 0 +) si le fichier n'est pas vide
#Si le fichier /TMP/myScriptName.return n'existe pas, alors le code retour est 0

myLongScriptName=${0}
myShortScriptName=$(basename ${myLongScriptName})
if [ -r /tmp/${myShortScriptName}.content ];
then
  cat /tmp/${myShortScriptName}.content
else
  echo ${myLongScriptName} $@
  if [ ! -t 0 ];
  then
    #Mode non interactif, IE on a une entree stdin
    cat -
  fi
fi

if [ -r /tmp/${myShortScriptName}.return ] && [ -s /tmp/${myShortScriptName}.return ];
then
  exit $(head -n 1 /tmp/${myShortScriptName}.return | xargs expr 0 +)
fi
exit 0
