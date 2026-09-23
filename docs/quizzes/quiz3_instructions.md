Make sure you have the updated repo version:

```
git pull
```

Start the Chipyard container:
```
docker compose run --rm chipyard
```

Load the Chipyard environment:
```
cd /workspace/chipyard
source env.sh
```

Compile BaselineConfig:
```
cd /workspace/chipyard/sims/verilator
make CONFIG=BaselineConfig
```

Run the provided ISP benchmark:

` quiz-run isp ` or the full path ` /workspace/course-scripts/quiz-run.sh isp ` should work with up-to-date repos.

This might take several minutes depending on your computer speed. The output should provide performance statistics for the different phases of isp_bench:  
gain  
vfilter  
downscale  
bgmodel  
detect  

Now, you are ready to answer Quiz 3 questions based on these stats.
