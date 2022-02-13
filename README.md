# Walltaker

> Oh rails, how I missed you.

## What is it?

Walltaker is inspired by the [WallClaimer](https://www.wallclaimer.com/) app, which allows you to set the wallpaper of
your friends phones. This however leads to some weird cases where people post stuff that'd be on your metaphorical
blacklist. With that in mind, I wanted it to be restricted to e621.net results, with an enforced blacklist. This keeps
you in control, but not _too much_ control.

## Clients
A client is required to set the wallpaper of a device. Here are some made by the awesome community!

| client                                                                          | platforms         |
|---------------------------------------------------------------------------------|-------------------|
| [Oddpaw's walltaker-go-client](https://github.com/oddpawsx/walltaker-go-client) | windows/mac/linux |

## API Guide
_Make your own client!_

You can make your own Walltaker client! A user should be able to supply any link ID, that you can then use to pull down
the latest wallpaper for that instance. I suggest you poll the endpoint ~10 seconds and cache the last post url, so you
can skip downloading if it hasn't changed since the last one.

### GET `http://joi.how:3000/links/[id].json`

🔓 No auth token required

Get the current post details for a given link.

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
}
```