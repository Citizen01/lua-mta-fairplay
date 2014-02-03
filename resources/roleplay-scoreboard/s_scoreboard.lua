--[[
	- FairPlay Gaming: Roleplay
	
	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.
	
	(c) Copyright 2014 FairPlay Gaming. All rights reserved.
]]

local news = {
	["date"] = "",
	["poster"] = "",
	["subject"] = "",
	["body"] = "",
	["link"] = ""
}

addEventHandler("onResourceStart", resourceRoot,
	function()
		--outputDebugString("Fetching latest news...")
		--callRemote("http://socialz.viuhka.fi/forum/getLatestNews.php", updateNews)
	end
)

addEvent(":_doGetServerName_:", true)
addEventHandler(":_doGetServerName_:", root,
	function()
		if (source ~= client) then return end
		triggerClientEvent(client, ":_doThrowServerName_:", client, getServerName())
	end
)

function getLatestNews(clientReturn)
	if (clientReturn) then
		if (source ~= client) then return end
		triggerClientEvent(client, ":_doFetchNews_:", client, news)
	else
		return news
	end
end
addEvent(":_doGetLatestNews_:", true)
addEventHandler(":_doGetLatestNews_:", root, getLatestNews)

function updateNews(date, poster, subject, body, link)
	--local link = tostring(string.gsub(string.gsub(link, "<a href=\"", ""), "\">2 comments</a>", ""))
	--local body = tostring(string.gsub(string.gsub(string.gsub(body, "<br />", "\n"), "<strong>", ""), "</strong>", ""))
	
	news = {
		["date"] = date,
		["poster"] = poster,
		["subject"] = subject,
		["body"] = body,
		["link"] = link
	}
	
	outputDebugString("Updated latest news.")
	triggerClientEvent(root, ":_doFetchNews_:", root, news)
end