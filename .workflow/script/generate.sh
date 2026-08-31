#!/usr/bin/env bash
set -euo pipefail

scriptPath="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repoPath="$(cd -- "$scriptPath/../.." && pwd)"
outputPath="$repoPath/output"
traceTempPath="$(mktemp -d)"
traceBuildPath="$traceTempPath/obj_dir"

cleanup()
{
    rm -rf -- "$traceTempPath"
}

trap cleanup EXIT

log()
{
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

totalStart=$SECONDS
log "开始生成 EXP1-EXP23"

rm -rf -- "$outputPath"
mkdir -p -- "$outputPath"

log "编译 Verilator trace 仿真器"
if ! make \
    -C "$repoPath/mycpu_env/gettrace" \
    verilator-build \
    VERILATOR_MDIR="$traceBuildPath" \
    >"$traceTempPath/build.log" 2>&1
then
    cat "$traceTempPath/build.log"
    exit 1
fi

for num in {1..23}
do
    expStart=$SECONDS
    progress="$(printf '[%02d/23]' "$num")"

    if [ "$num" -le 4 ]; then # EXP1 - EXP4
        log "$progress EXP$num：复制数字电路实验环境"
        cp -r -- "$repoPath/dc_env/exp$num" "$outputPath"
    elif [ "$num" -eq 5 ]; then # EXP5
        log "$progress EXP$num：复制 MiniCPU 实验环境"
        cp -r -- "$repoPath/minicpu_env" "$outputPath/exp$num"
    elif [ "$num" -eq 17 ]; then # EXP17
        log "$progress EXP$num：复制 TLB 模块验证环境"
        cp -r -- "$repoPath/mycpu_env/module_verify/tlb_verify" "$outputPath/exp$num"
    elif [ "$num" -eq 20 ]; then # EXP20
        log "$progress EXP$num：复制 Cache 模块验证环境"
        cp -r -- "$repoPath/mycpu_env/module_verify/cache_verify" "$outputPath/exp$num"
    else # EXP6 - 23 (exclude 17、20)
        expPath="$outputPath/exp$num"
        log "$progress EXP$num：复制 CPU 实验环境"
        cp -r -- "$repoPath/mycpu_env" "$expPath"
        log "$progress EXP$num：生成 COE 文件"
        make -C "$expPath/func" EXP="$num"
        log "$progress EXP$num：生成 trace 比对文件"
        make \
            -C "$expPath/gettrace" \
            verilator-run \
            VERILATOR_MDIR="$traceBuildPath"

        log "$progress EXP$num：整理实验目录"
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

    log "$progress EXP$num：完成，耗时 $((SECONDS - expStart)) 秒"
done

log "校验 COE 和 trace 文件"
for num in {6..16} 18 19 {21..23}
do
    test -s "$outputPath/exp$num/func/obj/inst_ram.coe"
    test -s "$outputPath/exp$num/gettrace/golden_trace.txt"
done

log "全部完成：23 个实验目录，16 组 COE/trace，耗时 $((SECONDS - totalStart)) 秒"
