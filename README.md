# Walltaker

> Oh rails, how I missed you.

## What is it?

Walltaker is inspired by the [WallClaimer](https://www.wallclaimer.com/) app, which allows you to set the wallpaper of
your friends phones. This however leads to some weird cases where people post stuff that'd be on your metaphorical
blacklist. With that in mind, I wanted it to be restricted to e621.net results, with an enforced blacklist. This keeps
you in control, but not _too much_ control.

## Clients
A client is required to set the wallpaper of a device. Here are some made by the awesome community!

| client                                                                                        | platforms                                                                                 |
|-----------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|
| [walltaker-desktop-client](https://github.com/PawCorp/walltaker-desktop-client)               | windows/mac/linux                                                                         |
| [walltaker-android-client](https://github.com/PawCorp/walltaker-android-client)               | android                                                                                   |
| [Lycraon's Wallpaper Engine Client](https://github.com/Lycraon/Walltaker-for-WallpaperEngine) | [Wallpaper Engine](https://store.steampowered.com/app/431960/Wallpaper_Engine/) (windows) |
| [Deanskond's Automate Client](https://github.com/Deanskond/walltaker_automate)                | [Automate App](https://llamalab.com/automate/) (android)                                  |

## API Guide
_Make your own client!_

You can make your own Walltaker client! A user should be able to supply any link ID, that you can then use to pull down
the latest wallpaper for that instance. I suggest you poll the endpoint ~10 seconds and cache the last post url, so you
can skip downloading if it hasn't changed since the last one.

---

### GET `http://walltaker.joi.how/api/links/[id].json`

🔓 No API key required

Get the current post details for a given link.

#### Response:
```json
{
  "id": 1, // The ID, you already know this
  "expires": "2025-03-05T00:00:00.000Z", // Expiry timestamp, will be inaccessible after this time
  "user_id": 1, // The user this refers to, currently not useful
  "terms": "I'm trying out something new, break this please! :)", // Open text feild for user to describe terms of posting
  "blacklist": "feet blood", // e621 style blacklist
  "post_url": "https://static1.e621.net/data/5d/87/5d87428c4839b0dc7d585b87a25af61a.png", // Full size post image
  "post_thumbnail_url": "https://static1.e621.net/data/preview/5d/87/5d87428c4839b0dc7d585b87a25af61a.jpg", // Thumnail size post image
  "post_description": "", // E621 post description
  "created_at": "2022-03-08T01:01:50.142Z", // Timestamp of link creation
  "updated_at": "2022-03-13T21:39:01.828Z", // Timestamp of last update from the server (should be close to current time UTC, unless something went wrong)
  "set_by": "name", // the username of the user who set the wallpaper (or null if anon)
  "response_type": "horny", // response type used, "horny" | "disgust" | "came", see chart below
  "response_text": "HUFF wow", // response text used
  "online": true // if this link has been pinged recently
}
```

---

### POST `http://walltaker.joi.how/api/links/[id]/response.json`

🔑 Requires user's API Key

Set a reponse for a given link. There are 3 kinds of responses.

| `type`      | Shown In UI as | Effect                                                                                |
|-------------|----------------|---------------------------------------------------------------------------------------|
| `"horny"`   | Love it        | User who set wallpaper gets notification, response `text` displayed on link in webapp |
| `"disgust"` | Hate it        | User who set wallpaper gets notification, wallpaper rolled back to previous image     |
| `"came"`    | Came           | User who set wallpaper gets notification, response `text` displayed on link in webapp |

⚠️ I suggest re-pinging the link after sending a `"disgust"` response, so you can reset the user's wallpaper to the previous version as soon as possible.

#### Request:
The body must be a valid JSON string, like shown below

```http request
POST http://walltaker.joi.how/api/links/[id]/response.json HTTP/1.1
Content-Type: application/json;
{
  "api_key": "23unFe3i"  // User's API key, always 8 characters long, REQUIRED
  "type": "horny"        // "horny" | "disgust" | "came", horny will be used if not supplied
  "text": "mmph nice"    // User's supplied text, an empty string will be used if not supplied
}
```

#### Response:
```json
{
  ... see link response ...
}
```

---

### GET `http://walltaker.joi.how/api/users/[username].json`

🔓 No API key required

Get details about this user's status such as if they're online, a friend, or the currently authenticated user for a given session.

#### Response:
```json

{
  "username": "apple", // The user's name
  "id": 24, // The user's internal ID
  "online": true, // If the user is online, meaning they have pinged a link recently
  "links": [ // Public links owned by this user, both online and offline.
    ... see link response ...
  ],
  "friend": true, // 🔐 If they are a friend of this session's user, requires Authentication token in header.
  "self": false // 🔐 If they are logged in as this session's user, requires Authentication token in header.
}
```