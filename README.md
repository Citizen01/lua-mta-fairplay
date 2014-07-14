## FairPlay Gaming MTA
### Installation

Simply place all the resources into your `resources` folder. After that you have to go into your `mtaserver.conf` and add the following line.

```lua
<resource src="roleplay-initializer" startup="1" default="true" protected="1" />
```

Make sure you set the MySQL configuration in `roleplay-accounts/s_accounts.lua` file. If you want to synchronize data properly with a web server (used for player tracking and real-time weather synchronization), add your server information into `roleplay-accounts/s_webserver.lua`. Make sure you've uploaded web files into your website as well. You can set the server address in `roleplay-weather/s_weather.lua`, and `roleplay-accounts/s_sync.lua` where the `sendPlayerAmount` function calls for a remote page. These are by default set to the public API URL address hosted by FairPlay Gaming, meaning you will not need to have a website unless you want to update your player count to a website and then display it on your forums for example - my website is not storing that data anywhere for obvious reasons.

MySQL database dump is located within the repository, so make sure to import that to your database server.

You might also have to set all resources in the admin ACL group in the `acl.xml` file in the `/deathmatch` folder of your server. This way you will avoid issues with remote connections and such. You may use the included `acl.xml` file for that instead of figuring it out yourself but I do not guarantee security for that.

I do not offer direct support with the gamemode as this is not really a public project, I uploaded this for other reasons.

### Description

You have just arrived to Los Santos. The city of the rich and the city of the poor - Vinewood stars and gangbangers through out the city. Take a peek behind the Vinewood hills at the country side or live among the famous stars at Richman district. It is all your choice.

Join the peacekeepers, also known as the San Andreas State Police, or join the hardworking fire fighters at San Andreas Medical and Fire Rescue Department. You can join a gang and begin the journey to become the hoods' king. You can also work at businesses, such as the Los Santos News Office, or a local bakery. You can become anything you want in Los Santos, to make it simple.

### What's new

Totally scripted from a scratch, given a look of our own to give it a finishing, truly amazing touch. Design looks great and works out well with nearly any resolution. Giving you the exclusive feeling of real roleplay and close to real life economy, it will be a great chance to improve your skills and experience something greately new and fancy. No more fancy cars roaming throughout the city in a week after the release, but making it nearly impossible for everybody to have access to such amount of money. Tens of thousands lines of code piling up and more to come. There are so many new things, that I couldn’t fit them in this description. You have to take a look in-game to get the real deal.

### Arrival

When you create a character, you will go through a simple process of giving yourself a name, description, gender, race and outfit. After finished, you will arrive at Unity Station just next to the city center also known as Pershing Square, surrounded by the court house, police station, city hall and a few good hotels and apartment complexes to stay and have a nap at.

### Factions

Giving you the ability to create your very own company without long waiting is just amazing. Pure and simple, very straight-forward. Fill up a form in-game and the employees of the City Hall will process it through for you. A wait of one day gives you access to all features of the company elements. Even though employees, a premade wage list, description and budget are needed, it will do everything for you so you can just have seat and a drink! You are able to hire people to work for you and they will be payed their wage for their work hours. Everything will be logged, so you will be able to find out if some employees are not doing their job.

### Vehicles

Giving you a realistic touch of driving and making it a bit more difficult ensures that driving will never again be unbalanced and unrealistic. Access vehicles with keys or hotwire and steal them if you have the right tools and skills! Car running low on gasoline? Stop at the next gas station to fill up the gas tank and perhaps have a tasty cup of coffee inside in the store. Instead of not having trouble with changing gears before, now you have to pay attention to that as well. You are able to buy a vehicle with either manual or automatic transmission and both have their ups and downs while driving.

### Interiors

Ability to purchase your own properties and manage them has always been amazing and fun. Having a place to live at is great. Why not buy a big house with a lot of space in the back, including a big cosy pool! Have a swim or dive, either way it's always refreshing and cooling you up on a hot sunny summer day. There are over a hundred interior looks to choose from and more to come! Several hundred of interiors created in-game so there will always be a house to buy.

### Seasons & Weather

Spring, summer, fall, winter. All within the server and fully functional. Making streets and areas snowy when snowing, and making them hard to drive on, while during summer there is most of the time sunny and bright. These are taken into account in the script. Weather also changes dynamically and realistically.

### On a special note
Shaders by `Ren712` (http://community.mtasa.com/) and MTA:SA Wiki examples (http://wiki.mtasa.com/).
Very tiny snippets from the community and other resources, if those are left out, the main credit is mine, I guess (in addition, keep the copyrights up there, I made this open-source for a reason ok).
