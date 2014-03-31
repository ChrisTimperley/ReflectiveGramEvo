# Collate the results from each of the experiments into a single data frame.
results <- read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/global/keijzer-12.csv", header=TRUE, sep=",")
results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/global/keijzer-13.csv", header=TRUE, sep=","))
results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/global/keijzer-14.csv", header=TRUE, sep=","))
results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/global/keijzer-15.csv", header=TRUE, sep=","))
results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/global/keijzer-16.csv", header=TRUE, sep=","))

results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/local/keijzer-12.csv", header=TRUE, sep=","))
results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/local/keijzer-13.csv", header=TRUE, sep=","))
results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/local/keijzer-14.csv", header=TRUE, sep=","))
results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/local/keijzer-15.csv", header=TRUE, sep=","))
results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/local/keijzer-16.csv", header=TRUE, sep=","))

results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/none/keijzer-12.csv", header=TRUE, sep=","))
results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/none/keijzer-13.csv", header=TRUE, sep=","))
results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/none/keijzer-14.csv", header=TRUE, sep=","))
results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/none/keijzer-15.csv", header=TRUE, sep=","))
results <- rbind(results, read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/none/keijzer-16.csv", header=TRUE, sep=","))

# Get a list of unique benchmark functions.
benchmarks = unique(results$Benchmark)
print(benchmarks)

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