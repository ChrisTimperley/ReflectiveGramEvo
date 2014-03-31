results_none <- read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/none/keijzer-12.csv", header=TRUE, sep=",")
results_global <- read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/global/keijzer-12.csv", header=TRUE, sep=",")
results_local <- read.table("C:/Users/Steven/Documents/Code/ReflectiveGramEvo/benchmarks/local/keijzer-12.csv", header=TRUE, sep=",")

print("Keijzer-12: None vs. Global")

benchmarks = unique(results_none$Benchmark)
print(benchmarks)

res <- wilcox.test(Fitness ~ Measure, data=rbind(results_none, results_global))$p.value

print(res)