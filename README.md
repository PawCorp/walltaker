# Walltaker
https://walltaker.joi.how

> Oh rails, how I missed you.

## What is it?

Walltaker is inspired by the [WallClaimer](https://www.wallclaimer.com/) app, which allows you to set the wallpaper of
your friend's phones. This however leads to some weird cases where people post stuff that'd be on your metaphorical
blacklist. With that in mind, I wanted it to be restricted to e621.net results, with an enforced blacklist. This keeps
you in control, but not _too much_ control.

## Clients
A client is required to set the wallpaper of a device. Here are some made by the awesome community!

#### Desktop

| Client                                                                                        | Platforms                                                                                 |
|-----------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|
| [Chewtoy's Walltaker Engine](https://github.com/dogkisser/walltaker-engine/releases)          | Windows                                                                                   |
| [JBerliner's Walltaker.sh](https://gitlab.com/JBerliner/walltaker-client)                     | Linux                                                                                     |
| [Lycraon's Wallpaper Engine Client](https://github.com/Lycraon/Walltaker-for-WallpaperEngine) | [Wallpaper Engine](https://store.steampowered.com/app/431960/Wallpaper_Engine/) (Windows) |
| [MacOS Client](https://github.com/PawCorp/walltaker-macos/releases/latest)                    | MacOS                                                                                     |

#### Mobile

| Client                                                                                        | Platforms                                                                                 |
|-----------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|
| [Deanskond's Automate Client](https://github.com/Deanskond/walltaker_automate)                | [Automate App](https://llamalab.com/automate/) (Android)                                  |
| [Gios' Client](https://github.com/gios2/Walltaker-Changer/releases/latest)                    | Android                                                                                   |
| [iOS Widget](https://github.com/PawCorp/walltaker/blob/main/ios.md#ios-widget)                | iOS                                                                                       |

## API Guide
_Make your own client!_

You can make your own Walltaker client! A user should be able to supply any link ID, that you can then use to pull down
the latest wallpaper for that instance. I suggest you poll the endpoint ~10 seconds and cache the last post url, so you
can skip downloading if it hasn't changed since the last one.

---

### GET `https://walltaker.joi.how/api/links/[id].json`

🔓 No API key required

Get the current post details for a given link.

#### Response:
```json
{
  "id": 1, // The ID, you already know this
  "expires": "2025-03-05T00:00:00.000Z", // Expiry timestamp, will be inaccessible after this time
  "username": "gray", // The user this refers to, queryable at the /api/user/[username] endpoint.
  "terms": "I'm trying out something new, break this please! :)", // Open text field for user to describe terms of posting
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

### POST `https://walltaker.joi.how/api/links/[id]/response.json`

🔑 Requires user's API Key

Set a response for a given link. There are 3 kinds of responses.

| `type`      | Shown In UI as | Effect                                                                                |
|-------------|----------------|---------------------------------------------------------------------------------------|
| `"horny"`   | Love it        | User who set wallpaper gets notification, response `text` displayed on link in webapp |
| `"disgust"` | Hate it        | User who set wallpaper gets notification, wallpaper rolled back to previous image     |
| `"came"`    | Came           | User who set wallpaper gets notification, response `text` displayed on link in webapp |

⚠️ I suggest re-pinging the link after sending a `"disgust"` response, so you can reset the user's wallpaper to the previous version as soon as possible.

#### Request:
The body must be a valid JSON string, like shown below

```http request
POST https://walltaker.joi.how/api/links/[id]/response.json HTTP/1.1
Content-Type: application/json;
{
  "api_key": "23unFe3i",  // User's API key, always 8 characters long, REQUIRED
  "type": "horny",        // "horny" | "disgust" | "came", horny will be used if not supplied
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

### GET `https://walltaker.joi.how/api/users/[username].json?api_key=xxxxxxxx`

🔓/🔐 API key required for some, but not all data

Get details about this user's status such as if they're online, a friend, or the currently authenticated user for a given session.

ℹ️ To ensure this query is processed quickly, `set_by` has been excluded from the links array.

#### Response:
```json

{
  "username": "apple", // The user's name
  "id": 24, // The user's internal ID
  "set_count": 540, // How many wallpapers this user has set for others
  "online": true, // If the user is online, meaning they have pinged a link recently
  "links": [ // Public links owned by this user, both online and offline.
    ... see link response ...
  ],
  "authenticated": true, // If this request was authenticated with a api_key successfully
  "friend": true, // 🔐 If they are a friend of this api_key's user, requires api_key param.
  "self": false // 🔐 If they are logged in as this api_key's user, requires api_key param.
}
```
