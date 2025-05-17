#!/bin/bash



#git log --all --pretty=format:"%h|%H|%ad|%s" --date=iso | while IFS="|" read -r short_hash full_hash date msg; do
#  branches=$(git branch -r --contains "$full_hash" | sed 's/^[ *]*//' | tr '\n' ';' | sed 's/;$//')
#  printf "%s\t%s\t%s\t%s\t%s\n" "$short_hash" "$full_hash" "$date" "$msg" "$branches"
#done > git_commit_report.tsv




#!/bin/bash

# 1. 全リモートブランチ一覧を取得（空白除去・ソート）
branches=($(git branch -r | sed 's/^[ *]*//' | sort))

# 2. ヘッダー出力
{
  printf "ShortHash\tFullHash\tDate\tMessage"
  for branch in "${branches[@]}"; do
    printf "\t%s" "$branch"
  done
  printf "\n"
} > git_commit_matrix.tsv

# 3. 各コミットを処理してTSV形式で出力（ヘッダーに追記）
git log --all --pretty=format:"%h|%H|%ad|%s" --date=iso | while IFS="|" read -r shash fhash date msg; do
  {
    printf "%s\t%s\t%s\t%s" "$shash" "$fhash" "$date" "$msg"
    for branch in "${branches[@]}"; do
      if git branch -r --contains "$fhash" | grep -q "$branch"; then
        printf "\t●"
      else
        printf "\t"
      fi
    done
    printf "\n"
  }
done >> git_commit_matrix.tsv
