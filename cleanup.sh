find . '(' '(' -type f -a -name "*.log" ')' -o \
           '(' -name "*.ptau" ')' \
       ')' -type f ! -path "*/node_modules/*" ! -path "./plonky2-bencmark/*"

# TODO: be able too find delete the folder
#find . -path "*_benchmark_files/*" -type f


read -p "Are you sure you want to delte these files (y/n)?" CONT
if [ "$CONT" = "y" ]; then
  find . '(' '(' -type f -a -name "*.log" ')' -o \
            '(' -name "*.ptau" ')' \
        ')' -type f ! -path "*/node_modules/*" ! -path "./plonky2-bencmark/*" -delete
else
  echo "cleanup aborted";
fi
