# Collate the results from each of the experiments into a single data frame.
dir = "E:/Code/ReflectiveGramEvo/benchmarks/"

results <- read.table(paste(dir, "global/keijzer-12.csv", sep=""), header=TRUE, sep=",")
results <- rbind(results, read.table(paste(dir, "global/keijzer-14.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "global/keijzer-15.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "global/koza-1.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "global/koza-3.csv", sep=""), header=TRUE, sep=","))

results <- rbind(results, read.table(paste(dir, "local/keijzer-12.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "local/keijzer-14.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "local/keijzer-15.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "local/koza-1.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "local/koza-3.csv", sep=""), header=TRUE, sep=","))


results <- rbind(results, read.table(paste(dir, "none/keijzer-12.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "none/keijzer-14.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "none/keijzer-15.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "none/koza-1.csv", sep=""), header=TRUE, sep=","))
results <- rbind(results, read.table(paste(dir, "none/koza-3.csv", sep=""), header=TRUE, sep=","))

# Seperate the results by benchmark.
k12 <- subset(results, Benchmark=="keijzer-12")
k14 <- subset(results, Benchmark=="keijzer-14")
k15 <- subset(results, Benchmark=="keijzer-15")
k1 <- subset(results, Benchmark=="koza-1")
k3 <- subset(results, Benchmark=="koza-3")

# Draw a box-plot comparing the best fitness values achieved by each of the robustness
# measures across each benchmark function.
#png('k12.png')
boxplot(Fitness~Measure, data=k12, xlab="Robustness Measure", ylab="Best Fitness", main="Keijzer-12")
boxplot(Fitness~Measure, data=k14, xlab="Robustness Measure", ylab="Best Fitness", main="Keijzer-14")
boxplot(Fitness~Measure, data=k15, xlab="Robustness Measure", ylab="Best Fitness", main="Keijzer-15")
boxplot(Fitness~Measure, data=k1, xlab="Robustness Measure", ylab="Best Fitness", main="Koza-1")
boxplot(Fitness~Measure, data=k3, xlab="Robustness Measure", ylab="Best Fitness", main="Koza-3")
