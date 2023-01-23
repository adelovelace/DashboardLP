# Run this app with `python app.py` and
# visit http://127.0.0.1:8050/ in your web browser.

from dash import Dash, html, dcc
import plotly.express as px
import pandas as pd

app = Dash(__name__)

# assume you have a "long-form" data frame
# see https://plotly.com/python/px-arguments/ for more options
df = pd.read_csv("hoteles.csv")
df = df.sort_values('puntaje', ascending=False)

fig = px.bar(df, y="hotel", x="puntaje", color="puntaje",orientation='h')

app.layout = html.Div(children=[
    html.H1(children='Turismo: Hoteles del Ecuador'),

    html.Div(children='''
        Mejores Hoteles de Esmeraldas
    '''),

    dcc.Graph(
        id='example-graph',
        figure=fig
    )
])

if __name__ == '__main__':
    app.run_server(debug=True)
