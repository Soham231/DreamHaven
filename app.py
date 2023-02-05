import streamlit as st
import requests
import time
import os
from PIL import Image
from streamlit_lottie import st_lottie
import matplotlib.patches as mpatches
import matplotlib.pyplot as plt
import shapely.geometry as sgeom
import cartopy.crs as ccrs
import cartopy.io.shapereader as shpreader
import shapely.geometry as sgeom
import pandas as pd
import numpy as np
st.set_page_config(page_title="HappyNest", page_icon=":bird:", layout="wide")
df = pd.read_csv('finaldata2.csv');
lst = ['statename', 'state', 'normalizededucation', 'normalizedhealth', 'normalizedweather', 'normalizedcrime', 'normalizedrent']
finalColumns = df[df.columns.intersection(lst)]
finalColumns2 = pd.read_csv('heatdata.csv')
df = finalColumns.merge(finalColumns2, left_on = finalColumns.statename, right_on = finalColumns2.field1, how= "inner")
lst = ['statename', 'state', 'normalizededucation', 'normalizedhealth', 'normalizedcrime', 'normalizedrent', 'normalizedsunlight', 'normalizedheat', 'label']
finalData = df[df.columns.intersection(lst)]

def getStates(name):
    lab = finalData.loc[finalData.statename == name, 'label']
    returner = []
    for index, row in finalData.iterrows():
        if row['label'] == lab.item():
            returner.append(row['statename'])

    for i in returner:
        if i == name:
            returner.remove(i)
    return returner


categories = ['normalizededucation', 'normalizedhealth', 'normalizedcrime', 'normalizedrent', 'normalizedsunlight', 'normalizedheat']

statesConversionKey = {
    "AL": "Alabama",
    "AK": "Alaska",
    "AZ": "Arizona",
    "AR": "Arkansas",
    "CA": "California",
    "CO": "Colorado",
    "CT": "Connecticut",
    "DE": "Delaware",
    "FL": "Florida",
    "GA": "Georgia",
    "HI": "Hawaii",
    "ID": "Idaho",
    "IL": "Illinois",
    "IN": "Indiana",
    "IA": "Iowa",
    "KS": "Kansas",
    "KY": "Kentucky",
    "LA": "Louisiana",
    "ME": "Maine",
    "MD": "Maryland",
    "MA": "Massachusetts",
    "MI": "Michigan",
    "MN": "Minnesota",
    "MS": "Mississippi",
    "MO": "Missouri",
    "MT": "Montana",
    "NE": "Nebraska",
    "NV": "Nevada",
    "NH": "New Hampshire",
    "NJ": "New Jersey",
    "NM": "New Mexico",
    "NY": "New York",
    "NC": "North Carolina",
    "ND": "North Dakota",
    "OH": "Ohio",
    "OK": "Oklahoma",
    "OR": "Oregon",
    "PA": "Pennsylvania",
    "RI": "Rhode Island",
    "SC": "South Carolina",
    "SD": "South Dakota",
    "TN": "Tennessee",
    "TX": "Texas",
    "UT": "Utah",
    "VT": "Vermont",
    "VA": "Virginia",
    "WA": "Washington",
    "WV": "West Virginia",
    "WI": "Wisconsin",
    "WY": "Wyoming"
}


states = {
    "Alabama": "Known for its southern hospitality and history, with attractions such as the Civil Rights Trail, the Gulf Shores, and the USS Alabama Battleship Memorial Park.",
    "Alaska": "The largest state with breathtaking natural beauty, including glaciers, national parks, and opportunities for outdoor recreation like fishing and hunting.",
    "Arizona": "Rich in history and cultural heritage, with attractions such as the Grand Canyon, Sedona's Red Rocks, and Native American reservations.",
    "Arkansas": "Arkansas is a state located in the southern region of the United States, known for its diverse geography ranging from the Ozark Mountains to the fertile Arkansas Delta. The state offers a low cost of living, a rich cultural heritage, and outdoor recreational opportunities, making it a nice place to live for those seeking a balance of natural beauty and urban amenities.",
    "California": "Known for its diverse geography, ranging from the beaches of Southern California to the mountains of the Sierra Nevada, and is home to a thriving tech industry and some of the world's most famous attractions like Disneyland and Hollywood.",
    "Colorado": "Famous for its Rocky Mountains and world-renowned ski resorts, it also offers a vibrant city life in Denver and opportunities for outdoor recreation year-round.",
    "Connecticut": "Known for its rich history, including being one of the original 13 colonies, and its location along the coast of Long Island Sound. It also has a strong education system, including Ivy League schools like Yale University, and a thriving financial services industry in the city of Hartford.",
    "Delaware": "Known for its historic sites, including the First State National Historical Park and the colonial-era city of New Castle. It is also home to many beaches and is a popular destination for tax-free shopping.",
    "Florida": "Known for its warm weather, beaches, and theme parks, including Disney World and Universal Studios. It also has a growing tech industry and a vibrant cultural scene, including the famous Art Deco district in Miami.",
    "Georgia": "Known for its history, including being one of the original 13 colonies and the birthplace of Martin Luther King Jr. It is also home to the city of Atlanta, a major center of commerce and culture, as well as numerous natural attractions, including the Blue Ridge Mountains and the Okefenokee Swamp.",
    "Hawaii": "Known for its tropical climate, beautiful beaches, and unique cultural heritage, including its history as a royal kingdom and a melting pot of various immigrant groups. It is also a popular destination for outdoor recreation, including surfing, hiking, and snorkeling.",
    "Idaho": "Known for its scenic beauty, including the Rocky Mountains, the Snake River, and numerous parks and forests. It is also a popular destination for outdoor recreation, including skiing, fishing, and hunting.",
    "Illinois": "Known for its central location in the heart of the country and its rich history, including being the birthplace of Abraham Lincoln and the home of Chicago, one of the largest cities in the United States.",
    "Indiana": "Known for its strong agricultural heritage and its central location in the Midwestern United States. It is also home to many historical sites, including the Lincoln Boyhood National Memorial, and a growing tech industry centered in Indianapolis.",
    "Iowa": "Known for its strong agricultural heritage, including its status as a leading producer of corn and soybeans, and its rolling prairies and scenic rivers. It is also a popular destination for outdoor recreation, including fishing, hunting, and boating.",
    "Kansas": "Known for its central location in the United States and its strong agricultural heritage, including its status as a leading producer of wheat and cattle. It is also a popular destination for outdoor recreation, including fishing, hunting, and camping.",
    "Kentucky": "Known for its rich history, including being one of the original 13 colonies and the birthplace of Abraham Lincoln. It is also famous for its horse racing industry, centered in the city of Louisville, and its rolling hills and scenic rivers.",
    "Louisiana": "Known for its rich cultural heritage, including its history as a French colony and its status as the birthplace of jazz. It is also famous for its cuisine, including Cajun and Creole food, and its swampy bayous and delta regions.",
    "Maine": "Known for its rugged coastline, including its numerous bays, inlets, and rocky cliffs, and its strong maritime heritage. It is also a popular destination for outdoor recreation, including fishing, boating, and hiking.",
    "Maryland": "Known for its rich history, including being one of the original 13 colonies and the location of the Battle of Antietam during the Civil War. It is also famous for its scenic Chesapeake Bay and its location near the nation's capital, Washington, D.C.",
    "Massachusetts": "Known for its rich history, including being one of the original 13 colonies and the birthplace of the American Revolution. It is also famous for its strong education system, including Ivy League schools like Harvard University, and its location near Boston, a major center of commerce and culture.",
    "Michigan": "Known for its Great Lakes coastline, including the iconic Mackinac Bridge, and its strong industrial heritage, including the automobile industry. It is also a popular destination for outdoor recreation, including boating, fishing, and hunting.",
    "Minnesota": "Known for its scenic beauty, including the Boundary Waters Canoe Area Wilderness, and its strong agricultural heritage, including being a leading producer of sugar beets and turkeys. It is also a popular destination for outdoor recreation, including fishing, hunting, and skiing.",
    "Mississippi": "Known for its rich cultural heritage, including its history as a center of the Civil Rights Movement, and its status as the birthplace of blues music. It is also famous for its delta region, including the Mississippi River and its fertile farmland.",
    "Missouri": "Known for its strong agricultural heritage, including its status as a leading producer of soybeans and cattle, and its central location in the Midwestern United States. It is also famous for its association with Mark Twain and its rolling hills and scenic rivers.",
    "Montana": "Known for its rugged beauty, including the Rocky Mountains, and its strong association with the American West. It is also a popular destination for outdoor recreation, including skiing, fishing, and hunting.",
    "Nevada": "Known for its rugged beauty, including the Sierra Nevada Mountains and Lake Tahoe, and its association with the American West. It is also famous for its entertainment capital, Las Vegas, and its legal gambling and prostitution industries.",
    "New Hampshire": "Known for its rugged coastline, including the White Mountains and its famous resort town, Lake Winnipesaukee, and its strong association with the American Revolution. It is also a popular destination for outdoor recreation, including skiing, fishing, and hiking.",
    "New Jersey": "Known for its central location in the Northeastern United States and its association with the American Revolution. It is also famous for its strong pharmaceutical and biotech industries, and its scenic coastline, including the Jersey Shore.",
    "New Mexico": "Known for its rich cultural heritage, including its history as a center of indigenous cultures and its status as the birthplace of atomic energy. It is also famous for its rugged beauty, including the Chihuahuan Desert and the Sangre de Cristo Mountains.",
    "New York": "Known for its central location in the Northeastern United States and its strong association with American history and commerce, including Wall Street and the United Nations. It is also famous for its iconic skyline, including the Empire State Building, and its scenic beauty, including the Niagara Falls.",
    "North Carolina": "Known for its rich cultural heritage, including its history as a center of the Civil Rights Movement and its strong association with the American Revolution. It is also famous for its scenic beauty, including the Outer Banks and the Great Smoky Mountains, and its strong tobacco and furniture industries.",
    "North Dakota": "Known for its strong agricultural heritage, including its status as a leading producer of wheat and cattle, and its rolling prairies and scenic rivers. It is also a popular destination for outdoor recreation, including fishing, hunting, and camping.",
    "Ohio": "Known for its central location in the Midwestern United States and its strong industrial heritage, including the automobile and steel industries. It is also famous for its association with the American Civil War, including the Battle of Gettysburg, and its rolling hills and scenic rivers.",
    "Oklahoma": "Known for its strong agricultural heritage, including its status as a leading producer of wheat and cattle, and its central location in the Midwestern United States. It is also famous for its association with the American West, including the famous Land Run of 1889, and its rolling hills and scenic rivers.",
    "Oregon": "Known for its rugged beauty, including the Pacific coastline, the Cascade Mountains, and Crater Lake. It is also famous for its strong association with the American West, including the Oregon Trail, and its thriving tech industry centered in Portland.",
    "Pennsylvania": "Known for its strong association with American history and commerce, including being one of the original 13 colonies and the birthplace of the American Revolution. It is also famous for its strong steel and coal industries, and its scenic beauty, including the Appalachian Mountains and the Pocono Mountains.",
    "Rhode Island": "Known for its central location in the Northeastern United States and its strong association with the American Revolution. It is also famous for its strong maritime heritage, including being home to the prestigious Naval War College, and its scenic coastline, including Newport, a famous resort town.",
    "South Carolina": "Known for its rich history, including being one of the original 13 colonies and the location of key battles during the American Revolution. It is also famous for its scenic beaches and its strong agriculture, including its status as a leading producer of peaches and cotton.",
    "South Dakota": "Known for its rugged beauty, including the Black Hills, Badlands National Park, and numerous lakes and rivers. It is also a popular destination for outdoor recreation, including hunting, fishing, and skiing.",
    "Tennessee": "Known for its rich history, including being the site of key battles during the Civil War and the home of Nashville, the country music capital of the world. It is also famous for its rolling hills, scenic rivers, and strong agriculture, including its status as a leading producer of cotton.",
    "Texas": "Known for its large size and its rich history, including being the site of key battles during the Texan Revolution and the Mexican-American War. It is also famous for its oil industry, its strong economy, and its diverse landscapes, including deserts, forests, and beaches.",
    "Utah": "Known for its rugged beauty, including the Rocky Mountains, the Great Salt Lake, and numerous parks and forests. It is also a popular destination for outdoor recreation, including skiing, hiking, and fishing.",
    "Vermont": "Known for its scenic beauty, including the Green Mountains, the Lake Champlain valley, and numerous parks and forests. It is also a popular destination for outdoor recreation, including skiing, fishing, and hunting.",
    "Virginia": "Known for its rich history, including being one of the original 13 colonies and the location of key battles during the American Revolution and Civil War. It is also famous for its scenic Chesapeake Bay and its strong agriculture, including its status as a leading producer of peanuts and tobacco.",
    "Washington": "Known for its scenic beauty, including the Olympic Mountains, Puget Sound, and numerous parks and forests. It is also a major center of technology and innovation, home to companies like Amazon and Microsoft.",
    "West Virginia": "Known for its rugged beauty, including the Appalachian Mountains and numerous parks and forests. It is also a major center of the coal industry and a popular destination for outdoor recreation, including skiing, fishing, and hunting.",
    "Wisconsin": "Known for its scenic beauty, including the Great Lakes, the Wisconsin River, and numerous parks and forests. It is also a major center of agriculture, including its status as a leading producer of cheese, and a popular destination for outdoor recreation, including fishing, hunting, and boating.",
    "Wyoming": "Known for its scenic beauty, including the Grand Teton and Yellowstone National Parks and its rugged mountains and rolling hills. It is also a popular destination for outdoor recreation, including skiing, hiking, and hunting."
}


fig = plt.figure()
# to get the effect of having just the states without a map "background"
# turn off the background patch and axes frame
ax = fig.add_axes([0, 0, 1, 1], projection=ccrs.LambertConformal(),
                  frameon=False)
ax.patch.set_visible(False)

ax.set_extent([-125, -66.5, 20, 50], ccrs.Geodetic())

shapename = 'admin_1_states_provinces_lakes'
states_shp = shpreader.natural_earth(resolution='110m',
                                     category='cultural', name=shapename)

ax.set_title('Best States for YOU')
reader = shpreader.Reader(states_shp)
stateBigList = reader.records()
ax.axis('off')
fig.set_facecolor('black')
scores = {}
def makeScores(rankings, temp):
    totalRanking = 0
    for index, row in finalData.iterrows():
        for i, j in zip(rankings, categories):
            totalRanking+=int(i)*row[j]
        if temp == "hot":
            totalRanking += row['normalizedheat']
        if temp == "cold":
            totalRanking -= row['normalizedheat']
        scores[row['state']] = totalRanking
        totalRanking = 0
    keys, values = scores.keys(), scores.values()
    combined = [list(x) for x in zip(keys, values)]
    combinedSorted = sorted(combined,reverse=True, key = lambda row: row[1])
    combinedSortedName = [x[0] for x in combinedSorted]
    combinedSortedFloat = [x[1] for x in combinedSorted]
    normalized = [(x[1] - np.mean(combinedSortedFloat)) / np.std(combinedSortedFloat)+ 7 for x in combinedSorted]
    final = [[x,y] for x, y in zip(combinedSortedName, normalized)]
    print("RANKINNAME")
    print(combinedSortedName)
    print("NORMAL")
    print(normalized)
    colorRankings = {combinedSortedName[i]:normalized[i] for i in range(len(combinedSortedName))}
    print("COLORRANKIGN")
    print(colorRankings)
    return colorRankings,final[:5]

def colorize_state(stateAb, colorRankings):
    print("HERE")
    if (stateAb == 'NE' or stateAb == "DC"):
        return '#5E60CE'
    stateScore = colorRankings[stateAb]
    color = 'white'
    if (stateScore < 5):
        color = "#7400B8"
    elif (5.8> stateScore >= 5):
        color = "#5E60CE"
    elif (6.5 > stateScore >= 5.8):
        color = "#4ea8de"
    elif (7.3 > stateScore >= 6.5):
        color = "#48bfe3"
    elif (7.9 > stateScore >= 7.3):
        color = "#64dfdf"
    elif (8.4 > stateScore >= 7.9):
        color = "#72efdd"
    elif (9 > stateScore >= 8.4):
        color = "#51fbd6"
    elif (stateScore > 9):
        color = "#21de8f"
    return color



name = ""
cost = 1
education = 1
weather = 1
safety = 1
health = 1
temperature = ""

costImg = Image.open("images/Cost.png")
healthImg = Image.open("images/Health.png")
safetyImg = Image.open("images/Safety.png")
educationImg = Image.open("images/Education.png")
weatherImg = Image.open("images/Weather.png")
paraBanner = Image.open("images/paraBanner.png")


def load_lottieurl(url):
    r = requests.get(url)
    if r.status_code != 200:
        return None
    return r.json()


image = load_lottieurl("https://assets10.lottiefiles.com/packages/lf20_hooof5c8.json")
palm_tree = load_lottieurl("https://assets3.lottiefiles.com/packages/lf20_tjUMkSX4rg.json")

with st.container():
    leftCol, rightCol = st.columns((1.4, 1))
    with leftCol:
        st.write("")
        original_title = '<p style="font-family:Courier New; font-weight:bold; color:White; font-size:90px;">DreamHaven📍</p>'
        st.markdown(original_title, unsafe_allow_html=True)
        sub_heading = '<p style="font-family:Courier New; color:White; font-size: 30px;">Your dream destination, just a few clicks away...</p>'
        st.markdown(sub_heading, unsafe_allow_html=True)
    with rightCol:
        st_lottie(image, height=310, key="coding", width=-900)


st.write("")
st.write("")
st.write("")
st.write("")
st.markdown("<h1 style='font-family:Courier New;text-align: center; color: White;'>How it Works</h1>", unsafe_allow_html=True)
st.markdown("<h3 style='font-family:Courier New;text-align: center; color: White;'>Take a short quiz and answer a series of questions based on your preferences. Let our algorithm decide the best destination for you!</h3>", unsafe_allow_html=True)
st.write("")
st.write("")
st.write("")

st.markdown(
    """<style>
        .element-container:nth-of-type(3) button {
            height: 100em;

        }
        </style>""",
    unsafe_allow_html=True,
)

def results_form(stateArray, temp):
    colorRankings, results = makeScores(stateArray, temp)
    print("IN RESULT ")
    print(colorRankings)
    stateInfoDict = []
    for count, i in enumerate(results): 
        longStateName = statesConversionKey[i[0]]
        scoreState = i[1]
        stateInfoDict.insert(count, [longStateName, scoreState,i[0]])

    print("STATE INFO DCIT")
    print(stateInfoDict)
    print("DSKLJD")
    print(str(stateInfoDict[2][1]))
    st.write("---")
    with st.container():
        col1, col2= st.columns((0.80, 1))
        with col1:
            st.write("")
        with col2:
            with st.spinner('Gathering your results'):
                time.sleep(1)
        st.success('Done!')
    global name, education, weather, health, safety, cost, temperature
    original_title = '<p style="text-align: center; font-family:sans-serif; font-weight:bold; color:White; font-size:75px;">{}\'s Results</p>'
    st.markdown(original_title.format(name) ,unsafe_allow_html=True)
    IMcol1, IMcol2, IMcol3 = st.columns((1, 1.7, 1))
    for state in stateBigList:
        postalAb = state.attributes['postal']
        ax.add_geometries([state.geometry],
                        ccrs.PlateCarree(),
                        facecolor=colorize_state(postalAb, colorRankings),
                        edgecolor='black')

    # make two proxy artists to add to a legend
    first = mpatches.Rectangle((0, 0), 1, 1, facecolor="#21de8f")

    second = mpatches.Rectangle((0, 0), 1, 1, facecolor="#51fbd6")
    third = mpatches.Rectangle((0, 0), 1, 1, facecolor="#64dfdf")
    fourth = mpatches.Rectangle((0, 0), 1, 1, facecolor="#48bfe3")
    fifth = mpatches.Rectangle((0, 0), 1, 1, facecolor="#5e60ce")
    sixth = mpatches.Rectangle((0, 0), 1, 1, facecolor="#7400B8")
    labels = ['Best', " ", " ", " ", " "
            'Worst']
    ax.legend([first, second, third, fourth, fifth, sixth], labels,
            loc='lower left', bbox_to_anchor=(0.025, -0.1), fancybox=True)
    st.pyplot(fig)

 

    scene = Image.open("images/scene.png")


  #  with st.container():
   #     with IMcol1:
    #        st.write("")
     #   with IMcol2:
      #      #jmap = Image.open("images/US.png")
            #st.image(map, width=600)
     #   with IMcol3:
      #      st.write("")
    #1st column
    with st.container():
        col1, col2, col3 = st.columns([1,2.2,0.7])
        with col1:
            st.image(Image.open("states/"+stateInfoDict[0][2]+".JPG"), width=275)
        with col2:
            st.markdown('<p style="font-family:Georgia; color:White; font-size: 45px;">1. ' + stateInfoDict[0][0]+' </p>', unsafe_allow_html=True)
            st.markdown('<p style="font-family:Courier New; color:White; font-size: 15px;">'+states[stateInfoDict[0][0]]+'</p>', unsafe_allow_html=True)
        with col3:
            st.markdown('<p style="text-align: center; margin-top: 3vw; font-family:Impact; color:White; font-size: 64px;">'+ str(round(stateInfoDict[0][1],2))+'</p>', unsafe_allow_html=True)
    #2nd column
    st.write("")
    with st.container():
        col1, col2, col3 = st.columns([1,2.2,0.7])
        with col1:
            st.image(Image.open("states/"+stateInfoDict[1][2]+".JPG"), width=275)
        with col2:
            st.markdown('<p style="font-family:Georgia; color:White; font-size: 45px;">2. ' + stateInfoDict[1][0]+' </p>', unsafe_allow_html=True)
            st.markdown('<p style="font-family:Courier New; color:White; font-size: 15px;">'+states[stateInfoDict[1][0]]+'</p>', unsafe_allow_html=True)
        with col3:
            st.markdown('<p style="text-align: center; margin-top: 3vw; font-family:Impact; color:White; font-size: 64px;">'+ str(round(stateInfoDict[1][1],2))+'</p>', unsafe_allow_html=True)
    #3rd column
    st.write("")
    with st.container():
        col1, col2, col3 = st.columns([1,2.2,0.7])
        with col1:
            st.image(Image.open("states/"+stateInfoDict[2][2]+".JPG"), width=275)
        with col2:
            st.markdown('<p style="font-family:Georgia; color:White; font-size: 45px;">3. ' + stateInfoDict[2][0]+' </p>', unsafe_allow_html=True)
            st.markdown('<p style="font-family:Courier New; color:White; font-size: 15px;">'+states[stateInfoDict[2][0]]+'</p>', unsafe_allow_html=True)
        with col3:
            st.markdown('<p style="text-align: center; margin-top: 3vw; font-family:Impact; color:White; font-size: 64px;">'+ str(round(stateInfoDict[2][1],2))+'</p>', unsafe_allow_html=True)
    #4th column
    st.write("")
    with st.container():
        col1, col2, col3 = st.columns([1,2.2,0.7])
        with col1:
            st.image(Image.open("states/"+stateInfoDict[3][2]+".JPG"), width=275)
        with col2:
            st.markdown('<p style="font-family:Georgia; color:White; font-size: 45px;">4. ' + stateInfoDict[3][0]+' </p>', unsafe_allow_html=True)
            st.markdown('<p style="font-family:Courier New; color:White; font-size: 15px;">'+states[stateInfoDict[3][0]]+'</p>', unsafe_allow_html=True)
        with col3:
            st.markdown('<p style="text-align: center; margin-top: 3vw; font-family:Impact; color:White; font-size: 64px;">'+ str(round(stateInfoDict[3][1],2))+'</p>', unsafe_allow_html=True)
    #5th column
    st.write("")
    with st.container():
        col1, col2, col3 = st.columns([1,2.2,0.7])
        with col1:
            st.image(Image.open("states/"+stateInfoDict[4][2]+".JPG"), width=275)
        with col2:
            st.markdown('<p style="font-family:Georgia; color:White; font-size: 45px;">5. ' + stateInfoDict[4][0]+' </p>', unsafe_allow_html=True)
            st.markdown('<p style="font-family:Courier New; color:White; font-size: 15px;">'+states[stateInfoDict[4][0]]+'</p>', unsafe_allow_html=True)
        with col3:
            st.markdown('<p style="text-align: center; margin-top: 3vw; font-family:Impact; color:White; font-size: 64px;">'+ str(round(stateInfoDict[4][1],2))+'</p>', unsafe_allow_html=True)
    st.write("")
    st.write("---")
    st.write("")
    with st.container():
        col1, col2, col3 = st.columns([1, 2, 1])
        with col1:
            st.write("")
        with col2:
            st.markdown("<h4 style='color: White;text-align: center;'>Not sure about your options? Enter a state here to see the 4 most similar states!</h4>", unsafe_allow_html=True)
            name = st.text_input("", placeholder="Enter a state here!", key="label")
        with col3:
            st.write("")
    with st.container():
        col1, col2= st.columns((0.80, 1))
        with col1:
            st.write("")
        with col2:
            search = st.button("SEARCH", key="hihd")
            if search:
                with st.spinner('Gathering your results'):
                    time.sleep(1)
            if search:
                list_states(name)
                search = True
                st.session_state.search = search
            else:
                search = st.session_state.get("search", False)
                if search:
                    list_states(name)


def list_states(statename):
    stateNames = getStates(statename)

    with st.container():
        for value in stateNames:
            temp = '<p style="text-align: left; font-family:sans-serif; font-weight:bold; color:White; font-size:20px;">•{}</p>'
            st.markdown(temp.format(value), unsafe_allow_html=True)


def output_form():
    global name, education, weather, health, safety, cost, temperature
    st.write("---")
    st.markdown("<h3 style='color: White;text-align: center;'>What is your name?</h3>", unsafe_allow_html=True)
    name = st.text_input("", placeholder="Your Name")
    
    st.write("")

    with st.container():
        st.write("")
        st.markdown("<h3 style='color: White;text-align: center;'>What type of climate to you prefer?</h3>", unsafe_allow_html=True)
        temperature = st.selectbox('',('Cold 🥶', 'Hot 🥵', 'Temperate 🙂'))

    with st.container():
        st.write("")
        st.image(costImg)
    st.markdown("<h3 style='color: White;text-align: center;'>How important is cost of living to you?</h3>", unsafe_allow_html=True)
    st.markdown("<p style='color: White; text-align: center;'>In our data, we use rent prices to estimate a location’s cost-of-living. Rent prices can be a useful indicator of cost of living in a certain area for several reasons. Housing is often the largest expense in" + \
        "a person's budget, and changes in housing costs can significantly impact the overall cost of living. Rent prices reflect the demand for housing in an area, which is influenced by factors such as job opportunities, quality of schools, and access to amenities.</p>", unsafe_allow_html=True)
    cost = st.slider("", 1, 5, 1)

    st.write("")

    with st.container():
        st.write("")
        st.image(safetyImg)
    st.markdown("<h3 style='color: White;text-align: center;'>How important is safety to you?</h3>", unsafe_allow_html=True)
    st.markdown("<p style='color: White; text-align: center;'>For each location’s safety rating, we use the average violence and property crime rates. The crime rate is often used as an indicator of safety in an area because it reflects the level of criminal activity taking place there. A high crime rate can indicate that an area is unsafe, with a greater risk of criminal activities such as theft, robbery, and violent crimes. On the other hand, a low crime rate can indicate that an area is safe and secure, with low levels of criminal activity.</p>", unsafe_allow_html=True)
    safety = st.slider("", 1, 5, 1, key="1")

    st.write("")

    with st.container():
        st.write("")
        st.image(educationImg)
    st.markdown("<h3 style='color: White;text-align: center;'>How important is education to you?</h3>", unsafe_allow_html=True)
    st.markdown("<p style='color: White; text-align: center;'>For each location’s education rating, we used teacher to student ratio. The teacher to student ratio is often considered a good indicator of a school's value because it reflects the level of individual attention and support that students receive from teachers. A low teacher to student ratio, meaning there are fewer students per teacher, can indicate that students are receiving more individual attention and support, which can lead to better learning outcomes and academic performance. </p>", unsafe_allow_html=True)
    education = st.slider("", 1, 5, 1, key="2")
    
    st.write("")
    
    with st.container():
        st.write("")
        st.image(weatherImg)
    st.markdown("<h3 style='color: White;text-align: center;'>How important is weather to you?</h3>", unsafe_allow_html=True)
    st.markdown("<p style='color: White; text-align: center;'>For each location’s weather rating, we used hours of sunlight and average temperature to determine each location’s ranking. Hours of sunlight and temperature are good indicators of the weather because they affect the overall climate and conditions in an area. Longer hours of sunlight generally indicate warmer temperatures, while shorter hours of sunlight are associated with cooler temperatures. Additionally, temperature plays a crucial role in determining the type of weather patterns that occur in an area, such as precipitation and wind patterns. In general, areas with more moderate temperatures and ample sunlight are considered to have good weather, while areas with extreme temperatures and limited sunlight are considered to have harsh weather conditions.</p>", unsafe_allow_html=True)

    weather = st.slider("", 1, 5, 1, key="3")
    
    st.write("")
    
    with st.container():
        st.write("")
        st.image(healthImg)
    st.markdown("<h3 style='color: White;text-align: center;'>How important is general health to you?</h3>", unsafe_allow_html=True)
    st.markdown("<p style='color: White; text-align: center;'>For this section, we use mortality rate to give each location a health rating. The mortality rate of a location is a good indicator of the quality of health services in a particular area because it reflects the overall health and well-being of the population. A high mortality rate can indicate that the health services in a particular area are inadequate, as people die more often from preventable causes or from not receiving the necessary medical attention when they become sick. A low mortality rate, on the other hand, typically indicates that a location has access to quality healthcare, good living conditions, available preventive care and medical treatment, and a trained medical workforce.</p>", unsafe_allow_html=True)
    health = st.slider("", 1, 5, 1, key="7")
    
    with st.container():
        col1, col2= st.columns((0.85, 1))
        with col1:
            st.write("")
        with col2:
            submit = st.button("SUBMIT")
        if submit:
            results_form([cost, safety, education, weather, health], temperature)
            submit = True
            st.session_state.submit = submit
        else:
            submit = st.session_state.get("submit", False)
            if submit:
                results_form([cost, safety, education, weather, health], temperature)
                

    st.markdown(
        """
        <style>
        textinput {
            font-size: 3rem !important;
        }
        </style>
        """,
        unsafe_allow_html=True,
    )


with st.container():
    col1, col2= st.columns((0.85, 1))
    with col1:
        st.write("")
    with col2:
        button_clicked = st.button("BEGIN")

    if button_clicked:
        output_form()
        button_clicked = True
        st.session_state.button_clicked = button_clicked
    else:
        button_clicked = st.session_state.get("button_clicked", False)
        if button_clicked:
            output_form()

    st.write("""
    <style>
    button {
        height: 50px;
        width: 100px;
    }
    </style>
    """, unsafe_allow_html=True)



