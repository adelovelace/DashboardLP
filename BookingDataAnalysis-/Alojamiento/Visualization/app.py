# Run this app with `python app.py` and
# visit http://127.0.0.1:8050/ in your web browser.

from dash import Dash, html, dcc
import plotly.express as px
import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots
from dash import Dash, dcc, html, Input, Output

app = Dash(__name__,external_stylesheets=["Visualization/assets/style.css"])

df = pd.read_csv("../Data/hoteles_c.csv", sep=";")
df = df.sort_values('puntaje', ascending=False)

df_categories = pd.read_csv("../Data/category_hotels_c.csv",low_memory=False)

df_surronundings = pd.read_csv("../Data/surroundings_c.csv",low_memory=False, sep=";")

#Default
canton_default = df['provincia'].unique()[0]
categorias_default = df_categories[df_categories['provincia'] == canton_default]['categoria'].unique()
hoteles_default = df_categories[df_categories['provincia'] == canton_default]['hotel'].unique()[:8]

# fig = px.bar(df, y="hotel", x="puntaje", color="puntaje",orientation='h')

app.layout = html.Div(className="body",children=[
    html.Div(className='base', children=[
        html.Div(className="controllers", children=[
            html.H1(children='Hoteles en Ecuador', style={"padding-top": "10px", "color": '#1fccff'}),

            html.H3(children='Bienvenido al Dashboard de los Hoteles de Ecuador',
                    style={"padding-top": "20px", "color": '##444444'}),

            html.H4(
                children='Conoce los hoteles con las mejores puntuaciones y precios que tienen algunos cantones del Ecuador, según los datos de la plataforma Booking.',
                style={"padding-top": "20px", "color": '#424343'}),

            html.P("Seleccione Localidad: ", style={"text-align": "left", "padding-top": "20px"}),
            dcc.Dropdown(
                df['provincia'].unique(),
                canton_default,
                id='province_dropdown',
                className='drop-1'
            ),

            html.P("Seleccione Categoría: ", style={"text-align": "left", "padding-top": "20px"}),
            dcc.Dropdown(
                options=categorias_default,
                id='multidrop-cat',
                className='multidrop-cat',
                multi=True
            ),

            html.P("Seleccione Hoteles: ", style={"text-align": "left", "padding-top": "20px"}),
            dcc.Dropdown(
                options=hoteles_default,
                id='multidrop-hot',
                className='multidrop-hot',
                multi=True
            ),

            html.P("Distancia de lugares más cercanos (km): ", style={"text-align": "left", "padding-top": "20px"}),
            dcc.Slider(
                2,
                100,
                step=25,
                value=0,
                # marks={str(year): str(year) for year in df['year'].unique()},
                id='distance-slider'
            )
        ]),
        html.Div(className='content', children=[
            dcc.Graph(
                id='price_score_graph',
                className='graph-1'
            ),
            dcc.Graph(
                id='categories_graph',
                className='graph-2'
            ),
            dcc.Graph(
                id='distance_graph',
                className='graph-3'
            ),
        ]),

    ]),
    html.Div(className='foot',
    children=[
        html.P("Autor: Milca Valdez Flores."),
        html.P("Materia: Lenguajes de Programación. Término: 2022-II")
    ])
])


@app.callback(
    Output('price_score_graph', 'figure'),
    Output('multidrop-cat', 'options'),
    Output('multidrop-hot', 'options'),
    Output('multidrop-cat', 'value'),
    Output('multidrop-hot', 'value'),
    Input('province_dropdown', 'value'),)
def update_graph(province_value):
    dff = df[df['provincia'] == province_value]
    categories = df_categories[df_categories['provincia'] == province_value]['categoria'].unique()
    hoteles = df_categories[df_categories['provincia'] == province_value]['hotel'].unique()

    # Create figure with secondary y-axis
    fig = make_subplots(specs=[[{"secondary_y": True}]])

    # Add traces
    fig.add_trace(
        go.Scatter(x=dff['hotel'], y=dff['precio'], name="Price"),
        secondary_y=False
    )

    fig.add_trace(
        go.Scatter(x=dff['hotel'], y=dff['puntaje'], name="Score"),
        secondary_y=True,
    )

    # Add figure title
    fig.update_layout(
        title_text=f"Hoteles en {province_value}"
    )

    # Set x-axis title
    fig.update_xaxes(title_text=f"hotels")
    fig.layout.template= 'plotly_dark'

    # Set y-axes titles
    fig.update_yaxes(title_text="<b>price</b>", secondary_y=False)
    fig.update_yaxes(title_text="<b>score</b>", secondary_y=True)

    return fig,categories,hoteles,categories,hoteles
        # hoteles[0],hoteles

@app.callback(
    Output('categories_graph', 'figure'),
    Output('distance-slider', 'min'),
    Output('distance-slider', 'max'),
    Output('distance-slider', 'value'),
    Output('distance-slider', 'step'),
    Input('province_dropdown', 'value'),
    Input('multidrop-cat', 'value'),
    Input('multidrop-hot', 'value'))
def update_graph2(province_value,cat_values, hot_values):
    dff = df_categories[df_categories['provincia'] == province_value]
    dff = dff.sort_values('puntaje', ascending=False)

    dff_t = df_surronundings[df_surronundings['hotel'].isin(hot_values)]
    distance_surr = dff_t['distancia'].unique()

    fig = go.Figure()

    for hotel in hot_values:
        dff_h = dff[dff['hotel']==hotel]
        df_categorias = dff_h[dff_h['categoria'].isin(cat_values)].sort_values('categoria',ascending=True)
        categorias = df_categorias['categoria']
        values = df_categorias['score']

        fig.add_trace(go.Scatterpolar(
            r=values,
            theta=categorias,
            fill='toself',
            name=hotel.upper()
        ))

        fig.update_layout(
            polar=dict(
                radialaxis=dict(
                    visible=True,
                    range=[0, 10]
                )),
            showlegend=True
        )

        fig.layout.template = 'seaborn'
        fig.update_layout(
            title_text=f"Categorías"
        )

    if hot_values:
        return fig, distance_surr.min(), distance_surr.max(), distance_surr.max(), distance_surr.max() / 5
    return fig,0,100,100,100


# , {str(dis): str(dis) for dis in distance_surr}

@app.callback(
    Output('distance_graph', 'figure'),
    Input('multidrop-hot', 'value'),
    Input('distance-slider', 'value'))
def update_graph3(hot_values, distance_value):
    dff = df_surronundings[df_surronundings['hotel'].isin(hot_values)]
    dff = dff[dff['distancia'] <= distance_value]
    dff = dff.sort_values('puntaje', ascending=False)

    fig = px.scatter(dff, y="distancia", x="lugares",color="hotel")
    fig.update_traces(marker_size=10)
    fig.update_layout(scattermode="group", scattergap=0.75)

    fig.update_layout(
        title_text=f"Parques, Restaurantes, y demás lugares más cercanos"
    )
    fig.update_yaxes(title_text="<b>distancia (km)</b>")

    return fig


if __name__ == '__main__':
    app.run_server(debug=True)
