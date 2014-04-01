# Collate the results from each of the experiments into a single data frame.
dir = "E:/Code/ReflectiveGramEvo/benchmarks/"

results <- read.table(paste(dir, "global/keijzer-12.csv", sep=""), header=TRUE, sep=",")
results <- rbind(results, read.table(paste(dir, "global/keijzer-13.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "global/keijzer-14.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "global/keijzer-15.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "global/keijzer-16.csv", sep=""), header=TRUE, sep=","))

results <- rbind(results, read.table(paste(dir, "local/keijzer-12.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "local/keijzer-13.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "local/keijzer-14.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "local/keijzer-15.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "local/keijzer-16.csv", sep=""), header=TRUE, sep=","))

results <- rbind(results, read.table(paste(dir, "none/keijzer-12.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "none/keijzer-13.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "none/keijzer-14.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "none/keijzer-15.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "none/keijzer-16.csv", sep=""), header=TRUE, sep=","))

# Seperate the results by benchmark.
k12 <- subset(results, Benchmark=="keijzer-12")
k13 <- subset(results, Benchmark=="keijzer-13")
k14 <- subset(results, Benchmark=="keijzer-14")
k15 <- subset(results, Benchmark=="keijzer-15")
k16 <- subset(results, Benchmark=="keijzer-16")

# Draw a box-plot comparing the best fitness values achieved by each of the robustness
# measures across each benchmark function.
#png('k12.png')
boxplot(Fitness~Measure, data=k12, xlab="Robustness Measure", ylab="Best Fitness", main="Keijzer-12")
boxplot(Fitness~Measure, data=k13, xlab="Robustness Measure", ylab="Best Fitness", main="Keijzer-13")
boxplot(Fitness~Measure, data=k14, xlab="Robustness Measure", ylab="Best Fitness", main="Keijzer-14")
boxplot(Fitness~Measure, data=k15, xlab="Robustness Measure", ylab="Best Fitness", main="Keijzer-15")
boxplot(Fitness~Measure, data=k16, xlab="Robustness Measure", ylab="Best Fitness", main="Keijzer-16")
