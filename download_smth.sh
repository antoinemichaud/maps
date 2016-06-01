row_start=12000
col_start=16300

mkdir -p first_result/
row_id_start=50
row_id_end=65
col_id_start=138
col_id_end=160

files=''
for i in `seq $row_id_start $row_id_end`;
do
  for j in `seq $col_id_start $col_id_end`;
  do
	  url="http://wxs.ign.fr/yvmoikafaddadzmxvh6sdmjb/geoportail/wmts?SERVICE=WMTS&VERSION=1.0.0&REQUEST=GetTile&LAYER=GEOGRAPHICALGRIDSYSTEMS.MAPS&STYLE=normal&FORMAT=image/jpeg&TILEMATRIXSET=PM&TILEMATRIX=15&TILEROW=$(($i + $row_start))&TILECOL=$(($j + $col_start))&extParamId=aHR0cDovL3d3dy5nZW9wb3J0YWlsLmdvdXYuZnIvYWNjdWVpbA=="
	  echo $url
	  row_file_index=`printf %05d $i`
	  col_file_index=`printf %05d $j`

	  out=first_result/img-$row_file_index-${col_file_index}.jpg
    files="$files  $out"
	  if [ ! -f $out ]; then
	    curl $url -H 'Referer: http://www.geoportail.gouv.fr/accueil' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36' -H 'X-Requested-With: ShockwaveFlash/21.0.0.216' --compressed > $out
    fi
  done
done

montage -mode Concatenate -tile $(($col_id_end - $col_id_start + 1))x$(($row_id_end - $row_id_start + 1)) $files first_result.jpg
