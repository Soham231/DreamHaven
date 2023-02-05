# FindYourParadise

An HPCC Systems Hackathon Challenge!

# Challenge Overview

## Find Your Paradise by weighing selected "quality of life" factors

Have you ever thought about building an application that can help people find places to live that maximize their quality of life and happiness?

The goal of this challenge is to analyze numerous datasets across different categories and make correlations with the data, using the HPCC Systems platform. After analyzing, the participants will be asked to design an interface to query this data and assign it a scoring system, then deliver it to the user via ROXIE and show the user where they should most likely want to live. Users should be given choices in an easy-to-use form that when submitted will generate a unique set of scores based on locations (Example: By State).

Every person’s definition of what make them happy can vary depending on several factors. To this challenge, we have narrowed these factors to four (4) categories:
•	Crime 
•	Environment (Weather)
•	Health 
•	Education

**Crime** – A dataset by US State with crimes between 2018-2021 is provided. Data points can include the number of crimes by State and Violent Crimes by State.

**Climate** – A dataset of Storm Data in the US over the last 10 years will be provided. Data Points can include number of storms by State, also injuries and fatalities due to a weather incident.

**Health** – A mortality rate by State from 1980 to 2020 dataset will be provided. Data points can include total mortality and/or average mortality by year and State.

**Education** – A dataset of the number of public and private schools by State will be provided. Data points include total school by State and percentage of Private Schools available to the Total Schools by State. Also, enrollment and student-to-teacher ratio can be a factor.  

## Tools

Start by installing one or both of the following IDEs: 

Install the flagship ECL IDE if you are a Windows user [ECL IDE Install](https://hpccsystems.com/download/#h-bare-metal-non-containerized-platform).

If you have a Mac or Linux box, install the Visual Studio Code IDE for your appropriate O/S, and then refer to the Installation PDF in the Docs folder of this repository to configure your IDE for ECL usage.  
PDFs in the Docs folder of this repository can be found to guide you through the installation and configuration.

[VS-Code IDE Install Page](https://code.visualstudio.com/download).

Download QuickStart.mod located in this repository's root folder. This file has the initial code you need for this challenge. 
The import process will be discussed at the Workshops, but in both IDEs simply open the MOD file and follow the prompts. CTRL+O in the ECL IDE, and the F1 key in VS-Code will pop up the command dialog, and look for the "ECL: Import 'mod' file" command. 

If you need more information on the ECL jobs you are running please use [ECL Watch Page](http://54.177.201.47:8010)

**Note: This cluster will only be active during the event!** After the event, you can create your own localized container cluster, or visit our public "Play" Cluster: (https://play.hpccsystems.com:18010) 

For a quick start on ECL syntax, please visit the [Learn ECL](https://hpccsystems-solutions-lab.github.io/) page. 

## Additional Resources

- Learn ECL Academy
https://hpccsystems-solutions-lab.github.io

- ECL training containing six short videos
https://www.youtube.com/watch?time_continue=192&v=Lk78BCCtM-0

- ECL documentation
http://cdn.hpccsystems.com/releases/CE-Candidate-8.10.12/docs/EN_US/ECLLanguageReference_EN_US-8.10.12-1.pdf

- Visualization document
https://cdn.hpccsystems.com/releases/CE-Candidate-8.10.12/docs/EN_US/VisualizingECL_EN_US-8.10.12-1.pdf

- Standard Library
https://cdn.hpccsystems.com/releases/CE-Candidate-8.10.12/docs/EN_US/ECLStandardLibraryReference_EN_US-8.10.12-1.pdf

- Machine Learning
https://hpccsystems.com/download/free-modules/machine-learning-library


## Challenge Expectation

Judges will consider followings during final presentation:

- Problem that was chosen (What categories and datasets were selected)
- How you approached the solution
- Display results (ROXIE or Visualization)
- Drawing conclusion (Where is your Paradise?)
- Demo of work via a PowerPoint presentation or live demo

Data points will be created for each category, sorted by US State or by County. The product should be able to allow selection of one or all categories, and then weigh each category in order of importance. Based on the weight, a score will be generated for each category selected and a "Top 10" list of States with their weighed scores will be displayed.

## Tips for a Great Score

- Since your solution is the key part to this challenge you can use "#OPTION('obfuscateOutput', TRUE);" at the start of your code to hide it from being viewed on ECL Watchpage. If you decide to use #OPTION make sure to remove if from the WUID that you shared with the judges. When obfuscateOutput set to true, details are removed from the generated workunit, including ECL code, estimates of record size, and number of records.
- If you want to write the result to a file, make sure the file name starts with your team's name for uniqueness purpose.
- Make sure the query names are unique and easy to identify. Do not use generic names like test, mentors, or roxie. We suggest adding your team's name as well. General names will result in other teams overwriting your files, queries, and results
- We encourage team play so teams that help answer questions in the public forums will be considered favorably in judging.
- Direct emails and direct messages to judges asking for support will be **ignored** and it won't work in team's favor
- We also encourage students to leverage our community forum and/or StackOverflow for ECL coding related questions. Please make sure to tag your questions with **hpcc-ecl**.

## Mentors

<div class="mentors">

<div>
<img src="./Images/Bob.png" alt="Bob Foreman" width="100" height="100" />
<p><a href = "mailto: robert.foreman@lexisnexisrisk.com">Bob Foreman</a> has been an ECL Trainer for the past 12 years, and has been a Technology Teacher for longer than he wants to admit. He will be your primary onsite contact regarding all ECL related questions during this event.</p>
</div>

<div>
<img src="./Images/George.png" alt="George Foreman" width="100" />
<p><a href = "mailto: george.foreman@lexisnexisrisk.com">George Foreman</a> is our HPCC Systems Product Specialist and Technical Writer. He will be available onsite to help you with locating the resources you need during this event.</p>
</div>

<div>
<img src="./Images/Hugo.jpg" alt="Hugo Watanuki" width="100" />
<p><a href = "mailto: hugo.watanuki@lexisnexisrisk.com">Hugo Watanuki</a> is responsible for the HPCC Systems Summer Internship Program. He will be available online in our slack channel to help you with ECL questions and resources you might need during this event.</p>
</div>

<div>
<img src="./Images/MauroDM.jpg" alt="Mauro Marques" width="100" />
<p><a href = "mailto: mauro.marques@lexisnexisrisk.com">Mauro Marques</a> is a Senior Technical Support Engineer at LexisNexis Risk Solutions, and supports the development and delivery of training programs for the HPCC Systems platform in the Brazil region. He will also be available online in our slack channel to help you with ECL questions and resources you might need during this event.</p>
</div>

<div>
<img src="./Images/Alysson.png" alt="Alysson Oliveira" width="100" />
<p><a href = "mailto: alysson.oliveira@lexisnexisrisk.com">Alysson Oliveira</a> is a Software Engineer at LexisNexis Risk Solutions. His main role revolves around support and development of training programs for HPCC Systems in Brazil , covering the academic audience, computing and data professionals and researchers. He also works to establish partnerships with universities to offer undergraduate students the opportunity to work on scientific projects. He will also be available online in our slack channel to help you with ECL questions and resources you might need during this event.</p>
</div>
<div></div>
</div>

