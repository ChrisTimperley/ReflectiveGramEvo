# Collate the results from each of the experiments into a single data frame.
results <- read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/global/keijzer-12.csv", header=TRUE, sep=",")
results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/global/keijzer-14.csv", header=TRUE, sep=","))
results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/global/keijzer-15.csv", header=TRUE, sep=","))

results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/local/keijzer-12.csv", header=TRUE, sep=","))
results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/local/keijzer-14.csv", header=TRUE, sep=","))
results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/local/keijzer-15.csv", header=TRUE, sep=","))

results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/none/keijzer-12.csv", header=TRUE, sep=","))
results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/none/keijzer-14.csv", header=TRUE, sep=","))
results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/none/keijzer-15.csv", header=TRUE, sep=","))


print(results)

# Seperate the results by benchmark.
k12 <- subset(results, Benchmark=="keijzer-12")
k14 <- subset(results, Benchmark=="keijzer-14")
k15 <- subset(results, Benchmark=="keijzer-15")

# Draw a box-plot comparing the best fitness values achieved by each of the robustness
# measures across each benchmark function.
#png('k12.png')
boxplot(Fitness~Measure, data=k12, xlab="Robustness Measure", ylab="Best Fitness", main="Keijzer-12")
boxplot(Fitness~Measure, data=k14, xlab="Robustness Measure", ylab="Best Fitness", main="Keijzer-14")
boxplot(Fitness~Measure, data=k15, xlab="Robustness Measure", ylab="Best Fitness", main="Keijzer-15")
