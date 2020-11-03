echo """#EXTM3U
#EXT-X-VERSION:5
#EXT-X-STREAM-INF:-1
""" > stream.m3u8
for x in music/*; do 
	SONG="$x"
	BASE=$(basename "$x")
	mkdir "audio/$BASE"
	ffmpeg \
		-y -i "$SONG" \
		-c:a aac -b:a 128k -muxdelay 0 -f segment -sc_threshold 0 -segment_time 7 \
		-segment_list "out.m3u8" \
		-segment_format mpegts "audio/$BASE/file%d.m4a"
	cat out.m3u8 | sed "s/file/..\/audio\/$BASE\/file/" > "m3us/$BASE.m3u8"
	echo "m3us/$BASE.m3u8" >> stream.m3u8
	rm out.m3u8
done
