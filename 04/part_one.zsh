#!/opt/homebrew/bin/zsh
set -o rematchpcre

line_scores=()

function add_line_score {
  local line=$1
  if [[ $line =~ 'Card *\d*: (.*?) \| (.*)' ]]; then
     left_side=${match[1]}
     right_side=${match[2]}
  fi

  read -A winning_numbers <<< $left_side
  read -A drawn_numbers <<< $right_side

  local score=0
  for element in "${drawn_numbers[@]}"; do
   if (($winning_numbers[(I)$element])); then
     if (($score == 0)); then
       score=1
     else
       score=$((score*2))
     fi
   fi
  done

  line_scores+=($score)
}


while IFS= read -r line
do
  add_line_score $line
done < ./input

sum=0
for i in "${line_scores[@]}"; do
 sum=$((sum + i))
done

echo "Total score: $sum"
