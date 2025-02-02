#!/bin/sh
FILE_NAME=$1
OUTPUT_NAME=$2
if [ -z $FILE_NAME ]
then
echo "Oh $USER, please enlighten me with the name or path of the z80 assembly file that you wish for me to compile."
read FILE_NAME
if [ -z $FILE_NAME ]
then
echo "I am sorry $USER, but I am afraid that I cannot compile nothing, for there is nothing to compile. Farewell."
exit
fi
if [ -z $OUTPUT_NAME ]
then
echo "Very good. Now, $USER, please give unto me the name of the output file that you wish to have."
read OUTPUT_NAME
if [ -z $OUTPUT_NAME ]
then
echo "Very well. I shall be the one to partake in the task of giving a name to the compiled sequence of bytes.\nAll shall be well unless a file with the name I chose already exists, in which case it would be overwritten.\n"
OUTPUT_NAME="Z80_CODE.BIN"
fi
fi
elif [ -z $OUTPUT_NAME ]
then
echo "Oh $USER, please enlighten me with the name or path of the file where the output you desire will be recorded."
read OUTPUT_NAME
if [ -z $OUTPUT_NAME ]
then
echo "I understand. I shall name the output file with a generic name that can be found easily.\nHowever, if a file with that name exists, then it will be overwritten. Apologies if that is the case.\n"
OUTPUT_NAME="Z80_CODE.BIN"
fi
fi
vasmz80_oldstyle $FILE_NAME -chklabels -nocase -Dvasm=1 -Fbin -o $OUTPUT_NAME
