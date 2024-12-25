fullfile=$1
filename=$(basename "$fullfile")
extension="${filename##*.}"
filename="${filename%.*}"
echo "$fullfile", "$filename.mp4"
exec ffmpeg -protocol_whitelist "file,tls,tcp,https" -i "$fullfile" -bsf:a aac_adtstoasc -vcodec copy -c copy -crf 50 "$filename.mp4"