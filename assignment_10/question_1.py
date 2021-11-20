import numpy as np
import plotly.graph_objs as go
import plotly.express as px
from scipy import stats
import math


def get_n(k):
    return 3.46 * (10**8) * (k**(-0.661))


def question_one():
    # a
    start = 1
    end = 200
    vals = []
    for i in range(start, end):
        vals.append(get_n(i))
    # b
    y = np.asarray(vals)
    x = np.asarray(list(range(start, end)))
    log_y = np.log10(y)
    log_x = np.log10(x)


    mean = sum(x*y)/sum(y)
    numer = sum((np.array(x, dtype=float)**2)*y)
    variance = ((numer/sum(y)) - mean**2)

    print(mean, variance)
    # also a !
    fig = go.Figure()
    fig.add_trace(go.Scatter(x=log_x, y=log_y, mode='markers'))
    fig.update_layout(title='Log10 Frequency Distribution of Google Vocab (Unique) for 1 <= k < 200')
    fig.update_xaxes(title='Log10 k (frequency)')
    fig.update_yaxes(title='Log10 N sub k (number of words that appeared k times)')
    # fig.show()

    # c i
    unlogged_words_once = get_n(1)
    sum_words = 0
    for i in range(1, 10**7+1):
        sum_words += i*get_n(i)

    frac_words_that_appear_once = unlogged_words_once / sum_words

    print(f'Fraction of words that appear one time: {frac_words_that_appear_once}')
    # # c ii
    total_unique_words = 0
    for i in range(1, 10**7+1):
        total_unique_words += get_n(i)

    print(f'Amount of words that appear one time: {unlogged_words_once}')
    print(f'Proportion of words that appear once time: {unlogged_words_once/total_unique_words}')

    total_left_out = 0
    for i in range(1, 200):
        total_left_out += i*y[i-1]

    print(f'Proportion of words left out by Google: {total_left_out/sum_words}')


if __name__ == '__main__':
    question_one()