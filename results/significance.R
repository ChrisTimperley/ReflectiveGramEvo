##########################################################################
##########################################################################
#
# Computes the Vargha-Delaney A measure for two populations a and b.
#
# Equation numbers below refer to the paper:
# @article{vargha2000critique,
#  title={A critique and improvement of the CL common language effect size
#               statistics of McGraw and Wong},
#  author={Vargha, A. and Delaney, H.D.},
#  journal={Journal of Educational and Behavioral Statistics},
#  volume={25},
#  number={2},
#  pages={101--132},
#  year={2000},
#  publisher={Sage Publications}
# }
# 
# a: a vector of real numbers
# b: a vector of real numbers 
# Returns: A real number between 0 and 1 
AMeasure <- function(a,b){

    # Compute the rank sum (Eqn 13)
    r = rank(c(a,b))
    
    
    r1 = sum(r[seq_along(a)])

    # Compute the measure (Eqn 14) 
    m = length(a)
    n = length(b)
    A = (r1/m - (m+1)/2)/n

    A
}

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
  
  print(c(f,
          p_global, AMeasure(results_none$Fitness, results_global$Fitness),
          p_local, AMeasure(results_none$Fitness, results_local$Fitness)
          )
        )
  
}

# Calculate the distribution of fitness values for each benchmark.
for (f in benchmarks) {
  
  results_both <- subset(results, Benchmark==f)
  fitness_none <- subset(results_both, Measure=="None")$Fitness
  fitness_local <- subset(results_both, Measure=="Local")$Fitness
  fitness_global <- subset(results_both, Measure=="Global")$Fitness

  print(f)
  print("None:")
  print(quantile(fitness_none))
  print("Local:")
  print(quantile(fitness_local))
  print("Global:")
  print(quantile(fitness_global))
  print("")
  
  #print(paste(f, " [None]:", , sep=""))
  
}