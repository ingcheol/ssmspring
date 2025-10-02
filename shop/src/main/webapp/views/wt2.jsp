<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  #result{
    margin-top: 83px;
    width:auto;
    height:100px;
    border: 2px solid red;
    overflow: auto;
  }
  #map{
    width:auto;
    height:400px;
    border: 2px solid blue;
  }

</style>
<script>
  let map2={
    init:function(){
      this.makeMap(37.538453, 127.053110, '남산', 's1.jpg', 100);

      // 37.538453, 127.053110
      $('#sbtn').click(()=>{
        this.makeMap(37.538453, 127.053110, '남산', 's1.jpg', 100);
      });
      // 35.170594, 129.175159
      $('#bbtn').click(()=>{
        this.makeMap(35.170594, 129.175159, '해운대', 's2.jpg', 200);
      });
      // 33.250645, 126.414800
      $('#jbtn').click(()=>{
        this.makeMap(33.250645, 126.414800, '중문', 's3.jpg', 300);
      });
    },

    makeMap:function(lat, lng, title, imgName, target){
      let mapContainer = document.getElementById('map');
      let mapOption = {
        center: new kakao.maps.LatLng(lat, lng),
        level: 7
      }
      let map = new kakao.maps.Map(mapContainer, mapOption);
      let mapTypeControl = new kakao.maps.MapTypeControl();
      map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
      let zoomControl = new kakao.maps.ZoomControl();
      map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
    } // end makeMarkers
  }

  $(function(){
    map2.init();
  })
  let wt1 = {
    init:function(){
      $('#get_btn').click(()=>{
        let loc = $('#loc').val();
        this.getData(loc);
      });
    },
    getData:function(loc){
      $.ajax({
        url:'<c:url value="/getwt1"/>',
        data:{'loc':loc},
        success:(data)=>{
          console.log(data);
          this.display(data);
        }
      });
    },
    display:function(data){
      let txt = data.response.body.items.item[0].wfSv;
      $('#result').html(txt);
    }
  }
  $(function(){
    wt1.init();
  });
</script>
<div class="col-sm-10">
  <div class="row">
    <div class="col-sm-8">

      <h2>Wheather2</h2>
      <select id="loc">
        <option value="109">서울</option>
        <option value="159">부산</option>
        <option value="184">제주</option>
      </select>
      <button id="get_btn">Get</button>
      <h5 id="status"></h5>
      <div id="result"></div>
      <button id="sbtn" class="btn btn-primary">서울</button>
      <button id="bbtn" class="btn btn-primary">부산</button>
      <button id="jbtn" class="btn btn-primary">제주</button>
      <div id="map"></div>
    </div>
    <div class="col-sm-4">
      <div id="content"></div>
    </div>

  </div>


</div>
