import RTCClient from './rtc-client';
import {getDevices, serializeFormData, validator} from './common';
import "./assets/style.scss";
import 'bootstrap-material-design';

$(() => {
  let selects = null;

  $('body').bootstrapMaterialDesign();
  $("#settings").on("click", function (e) {
    e.preventDefault();
    $("#settings").toggleClass("btn-raised");
    $('#setting-collapse').collapse();
  });

  getDevices(function (devices) {
    selects = devices;
    devices.audios.forEach(function (audio) {
      $('<option/>', {
        value: audio.value,
        text: audio.name,
      }).appendTo("#microphoneId");
    })
    devices.videos.forEach(function (video) {
      $('<option/>', {
        value: video.value,
        text: video.name,
      }).appendTo("#cameraId");
    })
    selects.resolutions = [
      {
        value: "180p", name: "320x180 15fps 140kbps"
      },
      {
        value: "360p", name: "640x360 30fps 400kbps"
      },
      {
        value: "720p", name: "1280x720 24fps 1130kbps"
      }
    ]
    selects.resolutions.forEach(function (resolution) {
      $('<option/>', {
        value: resolution.value,
        text: resolution.name,
      }).appendTo("#resolution");
    })
  })

  const fields = ['appID', 'channel', 'url'];

  let rtc = new RTCClient();

  $("#join").on("click", function () {
    console.log("create")
    const params = serializeFormData();
    if (validator(params, fields)) {
      rtc.join(params);
    }
  })

  $("#addInjection").on("click", function () {
    console.log("addInjection")
    const params = serializeFormData();
    if (validator(params, fields)) {
      rtc.addRTMPInjectStream();
    }
  });

  $("#removeInjection").on("click", function () {
    console.log("removeInjection")
    const params = serializeFormData();
    if (validator(params, fields)) {
      rtc.removeRTMPInjectStream();
    }
  });

  $("#leave").on("click", function () {
    console.log("leave")
    const params = serializeFormData();
    if (validator(params, fields)) {
      rtc.leave();
    }
  })
})