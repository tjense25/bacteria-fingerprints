function main()
	for i in 1:1000
		count = parse(Int32, readline())
		bps = [parse(Float32, readline()) for j in 1:286]
		write(STDOUT, count)
		write(STDOUT, bps)
	end
end

main()
