import 'package:dio/dio.dart';
import 'package:technical_assignment/model/user_model.dart';
import 'package:mockito/annotations.dart';
List<UserModel>? mockUsers=[
   UserModel(
      login: "mojombo",
      id: 1,
      nodeId: "MDQ6VXNlcjE=",
      avatarUrl: "https://avatars.githubusercontent.com/u/1?v=4",
      gravatarId: "",
      url: "https://api.github.com/users/mojombo",
      htmlUrl: "https://github.com/mojombo",
      followersUrl: "https://api.github.com/users/mojombo/followers",
      followingUrl: "https://api.github.com/users/mojombo/following{/other_user}",
      gistsUrl: "https://api.github.com/users/mojombo/gists{/gist_id}",
      starredUrl: "https://api.github.com/users/mojombo/starred{/owner}{/repo}",
      subscriptionsUrl: "https://api.github.com/users/mojombo/subscriptions",
      organizationsUrl: "https://api.github.com/users/mojombo/orgs",
      reposUrl: "https://api.github.com/users/mojombo/repos",
      eventsUrl: "https://api.github.com/users/mojombo/events{/privacy}",
      receivedEventsUrl: "https://api.github.com/users/mojombo/received_events",
      type: "User",
      siteAdmin: false,
  ),
];

dynamic mockValues=[{1: false},{1: false}];
