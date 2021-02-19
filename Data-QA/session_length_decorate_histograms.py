import re
import sys
data = []
for line in sys.stdin:
    row = [int(v) for v in re.split(r'\t+', line)]
    data.append(row)
total_sessions_raw = sum([row[1] for row in data])
total_sessions_itm = sum([row[2] for row in data])
cumulative_sessions_raw = 0
cumulative_sessions_itm = 0
for row in data:
    cumulative_sessions_raw += row[1]
    cumulative_sessions_itm += row[2]
    decorated_row = row + [
        cumulative_sessions_raw / total_sessions_raw,
        cumulative_sessions_itm / total_sessions_itm
    ]
    print(*decorated_row)