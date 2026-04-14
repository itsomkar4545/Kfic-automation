import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Sample data
data = {
    'Category': ['A', 'B', 'A', 'C', 'B', 'A', 'C', 'B'],
    'Value': [10, 20, 15, 25, 30, 12, 18, 22],
    'Region': ['North', 'South', 'North', 'East', 'South', 'West', 'East', 'North']
}

df = pd.DataFrame(data)
pivot_table = df.pivot_table(values='Value', index='Category', columns='Region', aggfunc='sum', fill_value=0)

plt.figure(figsize=(8, 6))
sns.heatmap(pivot_table, annot=True, cmap='Blues', fmt='d')
plt.title('Pivot Table Heatmap')
plt.tight_layout()
plt.savefig('pivot_table.png', dpi=300, bbox_inches='tight')
plt.show()