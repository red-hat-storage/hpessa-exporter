#!/usr/bin/awk -f
BEGIN {
	FS = ":.*##";
	printf "\nUsage:\n  make \033[36m<target>\033[0m\n"
}

/^[a-zA-Z_0-9-]+:.*?##/ {
	printf "  \033[36m%-24s\033[0m %s\n", $1, $2
}

/^##@/ {
	printf "\n\033[1m%s\033[0m\n", substr($0, 5)
}

END {
	printf "\n"
}
