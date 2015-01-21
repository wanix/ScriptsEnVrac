#!/bin/bash
################################################################################
# Author: Erwan SEITE (wanix.fr@gmail.com)
# Version : 0.1
# Date : 2014-12-11
################################################################################

#Parametrage necessaire version JAVA et compilation
DESTINATION_DIR="$HOME"
LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${DESTINATION_DIR}:/ODI/agent_standalone/oracledi.sdk/lib"
SPECIFIC_CLASSPATH="/ODI/agent_standalone_ve/oracledi.sdk/lib/odi-core.jar:/ODI/agent_standalone/opatch/oplan/jlib/apache-commons/commons-cli-1.0.jar:/ODI/agent_standalone/oracledi.sdk/lib/commons-lang-2.2.jar"
export LD_LIBRARY_PATH


echo "--------------------------------------------------------------------------------"
echo -n "  Give me the password :"
read PASSWORD

echo "--------------------------------------------------------------------------------"
echo "  Creating decrypt_odi.java"
cat << EOF > ${DESTINATION_DIR}/decrypt_odi.java
import com.sunopsis.dwg.DwgObject;

public class decrypt_odi {
  public static void main(String args[]) {
    String strSrcPassword = args[0];
    String strMasterPass=DwgObject.snpsDecypher(strSrcPassword);
    System.out.println("Encoded ¨Password : "+strSrcPassword+"\n");
    System.out.println("Decoded ¨Password : "+strMasterPass+"\n");
  }
}
EOF

echo "  Compiling"
${JAVA_HOME}/bin/javac -cp "${SPECIFIC_CLASSPATH}" -d "${DESTINATION_DIR}" "${DESTINATION_DIR}/decrypt_odi.java"
echo "  Cleaning source"
rm -f ${DESTINATION_DIR}/decrypt_odi.java
echo "--------------------------------------------------------------------------------"
echo "  Executing"
echo "  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
${JAVA_HOME}/bin/java -cp "${DESTINATION_DIR}:${SPECIFIC_CLASSPATH}" "decrypt_odi" \'${PASSWORD}\'
echo "  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "--------------------------------------------------------------------------------"
echo "  Cleaning class"
rm -f ${DESTINATION_DIR}/decrypt_odi.class
echo "--------------------------------------------------------------------------------"
exit 0
