args <- commandArgs(trailingOnly = T)
input_file <- read.csv(args[1])
output_file <- args[2]
png(file = output_file, bg = "white")
y = input_file$VALUES
mean <- mean(y)
barplot(rep(NA, length(y)), ylim = c(min(0, y), max(y)), axes = F)
abline(h = mean)
barplot(y, col = "red", border=NA, xpd=T, add = T)
text(0, mean - 100, paste("h = ", mean), col = "black", adj = c(0, -.1))
