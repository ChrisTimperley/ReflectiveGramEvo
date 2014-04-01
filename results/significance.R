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

# Get a list of unique benchmark functions.
benchmarks = unique(results$Benchmark)

# Calculate the p-values for each benchmark function.
for (f in benchmarks) {
  
  results_both <- subset(results, Benchmark==f)
  results_none <- subset(results_both, Measure=="None")
  results_local <- subset(results_both, Measure=="Local")
  results_global <- subset(results_both, Measure=="Global")
  
  p_global <- wilcox.test(Fitness ~ Measure, data=rbind(results_none, results_global))$p.value
  p_local <- wilcox.test(Fitness ~ Measure, data=rbind(results_none, results_local))$p.value
  
  print(c(f, p_global, p_local))
  
}