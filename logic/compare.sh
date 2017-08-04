#!/usr/bash
read -p "enter your score:" GRADE
if [ $GRADE -ge 85 ] && [ $GRADE -lt 100 ]; then
	echo "score is excellent"#statements
elif [ $GRADE -ge 70 ] && [ $GRADE -lt 84 ]; then
	echo "score is pass"
else
	echo "$GRADE is failure"
fi
