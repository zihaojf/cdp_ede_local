#!/usr/bin/env bash
set -euo pipefail

scriptPath="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repoPath="$(cd -- "$scriptPath/../.." && pwd)"
outputPath="$repoPath/output"

rm -rf -- "$outputPath"
mkdir -p -- "$outputPath"

for num in {1..23}
do
    if [ "$num" -le 4 ]; then # EXP1 - EXP4
        cp -r -- "$repoPath/dc_env/exp$num" "$outputPath"
    elif [ "$num" -eq 5 ]; then # EXP5
        cp -r -- "$repoPath/minicpu_env" "$outputPath/exp$num"
    elif [ "$num" -eq 17 ]; then # EXP17
        cp -r -- "$repoPath/mycpu_env/module_verify/tlb_verify" "$outputPath/exp$num"
    elif [ "$num" -eq 20 ]; then # EXP20
        cp -r -- "$repoPath/mycpu_env/module_verify/cache_verify" "$outputPath/exp$num"
    else # EXP6 - 23 (exclude 17、20)
        expPath="$outputPath/exp$num"
        cp -r -- "$repoPath/mycpu_env" "$expPath"
        make -C "$expPath/func" EXP="$num"
        make -C "$expPath/gettrace" iverilog

        if [ "$num" -eq 6 ]; then # need dram
            rm -rf -- "$expPath/module_verify"
            rm -rf -- "$expPath/soc_verify/soc_axi"
            rm -rf -- "$expPath/soc_verify/soc_bram"
            rm -rf -- "$expPath/soc_verify/soc_hs_bram"
        else
            rm -rf -- "$expPath/soc_verify/soc_dram" # mycpu_env del soc_dram
            rm -rf -- "$expPath/myCPU"
            if [ "$num" -eq 10 ]; then # need module_verify
                rm -rf -- "$expPath/soc_verify/soc_axi"
                rm -rf -- "$expPath/soc_verify/soc_hs_bram"
                rm -rf -- "$expPath/module_verify/tlb_verify"
                rm -rf -- "$expPath/module_verify/cache_verify"
            else
                rm -rf -- "$expPath/module_verify" # mycpu_env del module_verify
                if [ "$num" -eq 14 ]; then
                    rm -rf -- "$expPath/soc_verify/soc_axi"
                    rm -rf -- "$expPath/soc_verify/soc_bram"
                else
                    rm -rf -- "$expPath/soc_verify/soc_hs_bram"
                    if [ "$num" -le 13 ]; then
                        rm -rf -- "$expPath/soc_verify/soc_axi"
                    else
                        rm -rf -- "$expPath/soc_verify/soc_bram"
                    fi
                fi
            fi
        fi
    fi
done

for num in {6..16} 18 19 {21..23}
do
    test -s "$outputPath/exp$num/func/obj/inst_ram.coe"
    test -s "$outputPath/exp$num/gettrace/golden_trace.txt"
done
