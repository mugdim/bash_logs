#! /bin/bash
#skriptica by Mugdim

if [[ $# -ge 2 ]]; then
  if [[ -d $1 ]]; then
    tmpsize=( $(du -sh $1/*) )
    tmptotal_line=( $(wc -l $1/*) )
    tmpcount_line=( $(grep -c $2 $1/*) )
  else
    echo "The specified path does not exist";
    exit
  fi

  k=0
  for i in "${!tmpsize[@]}"; do
    if [ $((i%2)) -eq 0 ]; then
      size[k]=${tmpsize[i]}
      total_line[k]=${tmptotal_line[i]}
      ((j=i+1))
      name[k]=$(echo ${tmptotal_line[j]} | sed 's/.*\///')
      ((k=k+1))
    fi
  done

  for i in $(eval echo "{0..$((${#tmpcount_line[@]}-1))}"); do
    count_line[i]=$(echo ${tmpcount_line[i]} | sed 's/.*://')
  done

  for i in $(eval echo "{0..$((${#count_line[@]}-2))}"); do
    ((start=$i+1))
    if [ "$start" -le "${#count_line[@]}" ]; then
      for j in $(eval echo "{$start..$((${#count_line[@]}-1))}"); do
        if [ "${count_line[j]}" -gt "${count_line[i]}" ]; then
          temp1=${count_line[i]}
          count_line[i]=${count_line[j]}
          count_line[j]=$temp1
          temp2=${name[i]}
          name[i]=${name[j]}
          name[j]=$temp2
          temp3=${size[i]}
          size[i]=${size[j]}
          size[j]=$temp3
          temp4=${total_line[i]}
          total_line[i]=${total_line[j]}
          total_line[j]=$temp4
        fi
      done
    fi
  done

  name=("File name" "${name[@]}")
  size=("Size" "${size[@]}")
  total_line=("Total_lines" "${total_line[@]}")
  count_line=("Count of lines containing search word" "${count_line[@]}")

  printf '%s\n' "${name[@]}" "${size[@]}" "${total_line[@]}" "${count_line[@]}" | pr -4 -Ts
else
echo Not enough arguments! The scripts requires two arguments. If scripts have more of two arguments, scripts use only first two arguments. The script is used as follow: ./logs_stats.sh /Path/To/Directory Chrome/, where is first argument representing path of directory containing apache logs, and second one representing search string within logs.
fi
