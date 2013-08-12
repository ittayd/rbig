# <thomas.mccauley@cern.ch>

require 'sketchup.rb'
require 'bezier.rb'

$scale = 1.0
$rt = Geom::Transformation.rotation [0,0,0], [0,1,0], Math::PI/2.0
$st = Geom::Transformation.scaling $scale

def draw_as_wireframe(entities, collection, material)
  collection.each do |d|
    front_1 = d[1]      
    front_2 = d[2]
    front_3 = d[3]
    front_4 = d[4]

    back_1 = d[5]
    back_2 = d[6]
    back_3 = d[7]
    back_4 = d[8]

    corners = [front_1, front_2, front_3, front_4, back_1, back_2, back_3, back_4]

    corners.each do |corner|
      corner.transform! $st
      corner.transform! $rt
    end
     
    # front
    entities.add_line corners[0], corners[1]
    entities.add_line corners[1], corners[2]
    entities.add_line corners[2], corners[3]
    entities.add_line corners[3], corners[0]

    # back
    entities.add_line corners[4], corners[5]
    entities.add_line corners[5], corners[6]
    entities.add_line corners[6], corners[7]
    entities.add_line corners[7], corners[4]

    # connect the corners 
    entities.add_line corners[0], corners[4]
    entities.add_line corners[1], corners[5]
    entities.add_line corners[2], corners[6]
    entities.add_line corners[3], corners[7] 
   end
end

def draw_as_hybrid(entities, collection, material)
  collection.each do |d|
    front_1 = d[1]      
    front_2 = d[2]
    front_3 = d[3]
    front_4 = d[4]

    back_1 = d[5]
    back_2 = d[6]
    back_3 = d[7]
    back_4 = d[8]

    corners = [front_1, front_2, front_3, front_4, back_1, back_2, back_3, back_4]

    corners.each do |corner|
      corner.transform! $st
      corner.transform! $rt
    end
  
    begin
    # draw front and back as faces
    # and connect with lines
    # front
    e01 = entities.add_line corners[0], corners[1]
    e12 = entities.add_line corners[1], corners[2]
    e23 = entities.add_line corners[2], corners[3]
    e30 = entities.add_line corners[3], corners[0]

    front = entities.add_face [e01,e12,e23,e30]
    front.material = material
    front.back_material = material
  
    # back
    e45 = entities.add_line corners[4], corners[5]
    e56 = entities.add_line corners[5], corners[6]
    e67 = entities.add_line corners[6], corners[7]
    e74 = entities.add_line corners[7], corners[4]

    back = entities.add_face [e45,e56,e67,e74]
    back.material = material
    back.back_material = material
   
    entities.add_line corners[0], corners[4]
    entities.add_line corners[1], corners[5]
    entities.add_line corners[2], corners[6]
    entities.add_line corners[3], corners[7]
  rescue => e
    puts e
  end
  end
end

def draw_as_faces_v2(entities, collection, material)
  collection.each do |d|
    front_1 = d[1]      
    front_2 = d[2]
    front_3 = d[3]
    front_4 = d[4]

    back_1 = d[5]
    back_2 = d[6]
    back_3 = d[7]
    back_4 = d[8]

    corners = [front_1, front_2, front_3, front_4, back_1, back_2, back_3, back_4]

    corners.each do |corner|
      corner.transform! $st
      corner.transform! $rt
    end  
    
    # front
    e01 = entities.add_line corners[0], corners[1]
    e12 = entities.add_line corners[1], corners[2]
    e23 = entities.add_line corners[2], corners[3]
    e30 = entities.add_line corners[3], corners[0]

    front = entities.add_face [e01,e12,e23,e30]
    front.material = material
    front.back_material = material

    # back
    e45 = entities.add_line corners[4], corners[5]
    e56 = entities.add_line corners[5], corners[6]
    e67 = entities.add_line corners[6], corners[7]
    e74 = entities.add_line corners[7], corners[4]

    back = entities.add_face [e45,e56,e67,e74]
    back.material = material
    back.back_material = material

    # connect the corners 
    e04 = entities.add_line corners[0], corners[4]
    e15 = entities.add_line corners[1], corners[5]
    e26 = entities.add_line corners[2], corners[6]
    e37 = entities.add_line corners[3], corners[7]
  
    top = entities.add_face [e04,e01,e15,e45]
    top.material = material
    top.back_material = material
  
    bottom = entities.add_face [e37,e23,e26,e67]
    bottom.material = material
    bottom.back_material = material
  
    side1 = entities.add_face [e12,e26,e56,e15]
    side1.material = material
    side1.back_material = material
  
    side2 = entities.add_face [e30,e37,e74,e04]
    side2.material = material
    side2.back_material = material
  end
end

def draw_as_faces(entities, collection, material)
  collection.each do |d|
    front_1 = d[1]      
    front_2 = d[2]
    front_3 = d[3]
    front_4 = d[4]

    back_1 = d[5]
    back_2 = d[6]
    back_3 = d[7]
    back_4 = d[8]

    corners = [front_1, front_2, front_3, front_4, back_1, back_2, back_3, back_4]

    corners.each do |corner|
      corner.transform! $st
      corner.transform! $rt
    end

    # front
    front = entities.add_face corners[0], corners[1], corners[2], corners[3]
    front.material = material
    front.back_material = material
 
    # back
    back = entities.add_face corners[4], corners[5], corners[6], corners[7]
    back.material = material
    back.back_material = material
 
    # 4 sides
    side1 = entities.add_face corners[0], corners[4], corners[7], corners[3]
    side1.material = material
    side1.back_material = material
  
    side2 = entities.add_face corners[1], corners[5], corners[6], corners[2]
    side2.material = material
    side2.back_material = material
  
    top = entities.add_face corners[0], corners[4], corners[5], corners[1]
    top.material = material
    top.back_material = material
  
    bottom = entities.add_face corners[3], corners[7], corners[6], corners[2]
    bottom.material = material
    bottom.back_material = material
  end
end

def draw_as_front_face(entities, collection, material)
  collection.each do |d|
    front_1 = d[1]
    front_2 = d[2]  
    front_3 = d[3]
    front_4 = d[4]
    
    corners = [front_1, front_2, front_3, front_4]

    corners.each do |corner|
      corner.transform! $st
      corner.transform! $rt
    end
    
    face = entities.add_face corners[0], corners[1], corners[2], corners[3]
    face.material = material
    face.back_material = material
  end
end

def draw_as_back_face(entities, collection, material)
  collection.each do |d|
    back_1 = d[5]
    back_2 = d[6]
    back_3 = d[7]
    back_4 = d[8]

    corners = [back_1, back_2, back_3, back_4]

    corners.each do |corner|
      corner.transform! $st
      corner.transform! $rt
    end
    
    e1 = entities.add_line corners[0], corners[1] 
    e2 = entities.add_line corners[1], corners[2]
    e3 = entities.add_line corners[2], corners[3]
    e4 = entities.add_line corners[3], corners[0]
      
    face = entities.add_face [e1,e2,e3,e4]
    face.material = material
    face.back_material = material
  end
end
    
def draw_front_and_back(entities, collection, material)
  collection.each do |d|
    corners = [d[1], d[2], d[3], d[4], d[5], d[6], d[7], d[8]]
    
    corners.each do |corner|
      corner.transform! $st
      corner.transform! $rt
    end
    
    e1 = entities.add_line d[1], d[2]
    e2 = entities.add_line d[2], d[3]
    e3 = entities.add_line d[3], d[4]
    e4 = entities.add_line d[4], d[1]
    
    face = entities.add_face [e1,e2,e3,e4]
    face.material = material
    face.back_material = material
    
    e1 = entities.add_line d[5], d[6]
    e2 = entities.add_line d[6], d[7]
    e3 = entities.add_line d[7], d[8]
    e4 = entities.add_line d[8], d[5]
    
    back = entities.add_face [e1,e2,e3,e4]
    back.material = material
    back.back_material = material
  end
end

def draw_rechits(entities, collection, material, min_energy, energy_scale) 

  collection.each do |rh|
    energy = rh[0]

    if energy > min_energy

      f1 = Geom::Point3d.new rh[5]
      f2 = Geom::Point3d.new rh[6]
      f3 = Geom::Point3d.new rh[7]
      f4 = Geom::Point3d.new rh[8]

      b1 = Geom::Point3d.new rh[9]
      b2 = Geom::Point3d.new rh[10]
      b3 = Geom::Point3d.new rh[11]
      b4 = Geom::Point3d.new rh[12]

      diff1 = b1-f1
      diff2 = b2-f2
      diff3 = b3-f3
      diff4 = b4-f4

      diff1.normalize!
      diff2.normalize!
      diff3.normalize!
      diff4.normalize!

      energyScale = Geom::Transformation.scaling energy*energy_scale

      diff1.transform! energyScale  
      diff2.transform! energyScale
      diff3.transform! energyScale
      diff4.transform! energyScale

      corners = [f1, f2, f3, f4, f1+diff1, f2+diff2, f3+diff3, f4+diff4]

      corners.each do |corner|
        corner.transform! $rt
      end

      # front
      e01 = entities.add_line corners[0], corners[1]
      e12 = entities.add_line corners[1], corners[2]
      e23 = entities.add_line corners[2], corners[3]
      e30 = entities.add_line corners[3], corners[0]

      front = entities.add_face [e01,e12,e23,e30]
      if front
        front.material = material
        front.back_material = material
      end

      # back
      e45 = entities.add_line corners[4], corners[5]
      e56 = entities.add_line corners[5], corners[6]
      e67 = entities.add_line corners[6], corners[7]
      e74 = entities.add_line corners[7], corners[4]

      back = entities.add_face [e45,e56,e67,e74]
      if back
        back.material = material
        back.back_material = material
      end

      # connect the corners 
      e04 = entities.add_line corners[0], corners[4]
      e15 = entities.add_line corners[1], corners[5]
      e26 = entities.add_line corners[2], corners[6]
      e37 = entities.add_line corners[3], corners[7]
  
      top = entities.add_face [e04,e01,e15,e45]
      if top  
       top.material = material
        top.back_material = material
      end

      bottom = entities.add_face [e37,e23,e26,e67]
      if bottom
        bottom.material = material
        bottom.back_material = material
      end

      side1 = entities.add_face [e12,e26,e56,e15]
      if side1
        side1.material = material
        side1.back_material = material
      end

      side2 = entities.add_face [e30,e37,e74,e04]
      if side2
        side2.material = material
        side2.back_material = material
      end
    end
  end
end

def draw_tracks(entities, tracks, extras, assocs, pt_index, min_pt)

  assocs.each do |asc|    
     
    ti = asc[0][1]
    ei = asc[1][1] 

    track_pt = tracks[ti][pt_index]

    if track_pt > min_pt

      p1 = extras[ei][0]  
      d1 = extras[ei][1]
      p2 = extras[ei][2]
      d2 = extras[ei][3]
    
      p1.transform! $rt
      d1.transform! $rt
      p2.transform! $rt
      d2.transform! $rt

      #entities.add_cpoint p1
      #entities.add_cpoint p2
    
      v1 = Geom::Vector3d.new d1
      v2 = Geom::Vector3d.new d2
      
      v1.normalize!
      v2.normalize!  
    
      distance = (p2[0]-p1[0])*(p2[0]-p1[0])+((p2[1]-p1[1])*(p2[1]-p1[1]))+((p2[2]-p2[1])*(p2[2]-p2[1]))
      distance = Math.sqrt(distance)

      scale0 = distance*0.25
      scale1 = distance*0.25
     
      p3 = [p1[0]+ scale0*v1[0], p1[1]+ scale0*v1[1], p1[2]+ scale0*v1[2]]
      p4 = [p2[0]- scale1*v2[0], p2[1]- scale1*v2[1], p2[2]- scale1*v2[2]]
    
      pts = Bezier.points([p1,p3,p4,p2],16) 

      entities.add_curve pts

      # this is a straightline connecting the 
      # innermost and outermost states
      pts2 = [p1,p2]
      #entities.add_curve pts2

      # these are the line connecting the control points
      # to the first and last points
      pts3 = [p1,p3]
      pts4 = [p2,p4]
      #entities.add_curve pts3
      #entities.add_curve pts4
    end
  end
end

def process_json(input)
  input.gsub!(/\s+/, "")
  input.gsub!(":", "=>")
  input.gsub!("\'", "\"")
  input.gsub!("(", "[")
  input.gsub!(")", "]")
  input.gsub!("nan", "0")
  input
end

Sketchup.send_action "showRubyPanel:"

#gin = File.open("/Users/mccauley/rbig.git/Geometry/Run_1/Event_1", "r")
#geometry = eval(process_json(gin.read()))

#ein = File.open("/Users/mccauley/rbig.git/Events/Run_165970/Event_275108397", "r")
#ein = File.open("/Users/mccauley/Events/Run_146511/Event_234321706", "r")
#ein = File.open("/Users/mccauley/rbig.git/Events/Run_176304/Event_417897294", "r")
ein = File.open("/Users/mccauley/rbig.git/Events/Run_210534/Event_68185478","r")

event = eval(process_json(ein.read()))
puts "Event file read"
ein.close

gin = File.open("/Users/mccauley/rbig.git/cms-geometry.v4.rb", "r")
geometry = eval(gin.read())

puts "Geometry file read"
gin.close

g = geometry["Collections"]

model = Sketchup.active_model
entities = model.entities

materials = model.materials
alpha = 0.5

ecal_rechit_material = materials.add "EcalRecHit"
ecal_rechit_material.alpha = alpha
ecal_rechit_material.color = [1.0,0.2,0.0]

hcal_rechit_material = materials.add "HcalRecHit"
hcal_rechit_material.alpha = 0.9
hcal_rechit_material.color = [0.4,0.8,1.0]

tracker_material = materials.add "Tracker"
tracker_material.alpha = alpha
tracker_material.color = [0.7,0.7,0.0]

muon_chamber_material = materials.add "MuonChamber"
muon_chamber_material.alpha = 0.1
muon_chamber_material.color = [1.0,0.0,0.0]

ecal_material = materials.add "ECAL"
ecal_material.alpha = alpha
ecal_material.color = [0.5,0.8,1.0]

hcal_material = materials.add "HCAL"
hcal_material.alpha = 0.1
hcal_material.color = [0.7,0.7,0.0]

dt_material = materials.add "DT"
dt_material.alpha = alpha
dt_material.color = [0.8,0.4,0.0]

csc_material = materials.add "CSC"
csc_material.alpha = alpha
csc_material.color = [0.6,0.7,0.1]
 
rpc_material = materials.add "RPC"
rpc_material.alpha = alpha
rpc_material.color = [0.6,0.8,0.0]
 
dialog_args = {
  :dialog_title => "CMS Sketchup",
  :scrollable => true,
  :pref_key => "",
  :width => 200,
  :length => 700,
  :left => 400,
  :top => 400,
  :resizable => true
}

dialog = UI::WebDialog.new(dialog_args)
dialog.set_url "file:///Users/mccauley/rbig.git/dialog.html"

t = event["Types"]
c = event["Collections"]
a = event["Associations"]

types = {}

count = 0
t.each_key do |k|
  types[k] = count
  count = count + 1
end

dialog.add_action_callback("drawTrackDets") {
  draw_as_front_face(entities, c["TrackDets_V1"], tracker_material)
}

dialog.add_action_callback("drawMuonChambers") {
  draw_as_faces(entities, c["MuonChambers_V1"], muon_chamber_material)
}

dialog.add_action_callback("drawHBRecHits") {
  draw_rechits(entities, c["HBRecHits_V2"], hcal_rechit_material, 0.5, 0.5)
}

dialog.add_action_callback("drawHERecHits") {
  draw_rechits(entities, c["HERecHits_V2"], hcal_rechit_material, 0.5, 0.05)
}
  
dialog.add_action_callback("drawEBRecHits") {
  draw_rechits(entities, c["EBRecHits_V2"], ecal_rechit_material, 0.25, 0.5)
}

dialog.add_action_callback("drawEERecHits") {
  draw_rechits(entities, c["EERecHits_V2"], ecal_rechit_material, 0.5, 0.5)
}
  
dialog.add_action_callback("drawMuons") {
  muons = c["GlobalMuons_V1"]
  points = c["Points_V1"]
  assoc = a["MuonGlobalPoints_V1"]

  curve_points0 = []
  curve_points1 = []

  # warning, this is a hack. we assume that there are only 2 muons!

  assoc.each do |asc|
      mi = asc[0][1]
      pi = asc[1][1]
      points[pi][0].transform! $rt

      if mi == 0
        curve_points0.push(points[pi][0])
      end

      if mi == 1 
        curve_points1.push(points[pi][0])
      end
  end

  entities.add_curve curve_points0
  entities.add_curve curve_points1
}

dialog.add_action_callback("drawElectrons") {
  puts 'Drawing Electrons'
  draw_tracks(entities,c["GsfElectrons_V1"],c["Extras_V1"],a["GsfElectronExtras_V1"], 0, 5.0)
}

dialog.add_action_callback("drawTracks") {
  puts 'Drawing Tracks'
  draw_tracks(entities,c["Tracks_V2"],c["Extras_V1"], a["TrackExtras_V1"], 2, 0.0)
}

dialog.add_action_callback("drawPXB") {
  puts 'Drawing PXB'
  draw_as_front_face(entities, g["PixelBarrel3D_V1"], tracker_material)
}

dialog.add_action_callback("drawPEC") {
  puts "Drawing PEC"
  draw_as_front_face(entities, g["PixelEndcapPlus3D_V1"], tracker_material)
  draw_as_front_face(entities, g["PixelEndcapMinus3D_V1"], tracker_material)
}

dialog.add_action_callback("drawTIB") {
  puts "Drawing TIB"
  draw_as_front_face(entities, g["SiStripTIB3D_V1"], tracker_material)
}

dialog.add_action_callback("drawTOB") {
  puts "Drawing TOB"
  draw_as_front_face(entities, g["SiStripTOB3D_V1"], tracker_material)
}

dialog.add_action_callback("drawTEC") {
  puts "Drawing TEC"
  draw_as_front_face(entities, g["SiStripTECPlus3D_V1"], tracker_material)
  draw_as_front_face(entities, g["SiStripTECMinus3D_V1"], tracker_material)
}

dialog.add_action_callback("drawTID") {
  puts "Drawing TID"
  draw_as_front_face(entities, g["SiStripTIDPlus3D_V1"], tracker_material)
  draw_as_front_face(entities, g["SiStripTIDMinus3D_V1"], tracker_material)
}

dialog.add_action_callback("drawEB") {
  puts "Drawing EB"
  draw_as_wireframe(entities, g["EcalBarrel3D_V1"], ecal_material)
}

dialog.add_action_callback("drawEE") {
  puts "Drawing EE"
  draw_as_wireframe(entities, g["EcalEndcapPlus3D_V1"], ecal_material)
  draw_as_wireframe(entities, g["EcalEndcapMinus3D_V1"], ecal_material)
}

dialog.add_action_callback("drawHB") {
  puts 'Drawing HB'
  draw_as_hybrid(entities, g["HcalBarrel3D_V1"], hcal_material)
}

dialog.add_action_callback("drawHE") {
  puts 'Drawing HE+'
  draw_as_hybrid(entities, g["HcalEndcapPlus3D_V1"], hcal_material)
  puts 'Drawing HE-'
  draw_as_hybrid(entities, g["HcalEndcapMinus3D_V1"], hcal_material)
}
 
dialog.add_action_callback("drawHO") {
  puts 'Drawing HO'
  draw_as_hybrid(entities, g["HcalOuter3D_V1"], hcal_material)
}

dialog.add_action_callback("drawHF") {
  puts 'Drawing HF+'
  draw_as_faces(entities, g["HcalForwardPlus3D_V1"], hcal_material)
  puts 'Drawing HF-'
  draw_as_faces(entities, g["HcalForwardMinus3D_V1"], hcal_material)
}

dialog.add_action_callback("drawDT") {
  puts 'Drawing DT'
  draw_as_faces(entities, g["DTs3D_V1"], dt_material)
}

dialog.add_action_callback("drawCSC") {
  puts 'Drawing CSC+'
  draw_as_faces(entities, g["CSCPlus3D_V1"], csc_material)
  puts 'Drawing CSC-'
  draw_as_faces(entities, g["CSCMinus3D_V1"], csc_material)
}

dialog.add_action_callback("drawRPC") {
  UI.messagebox "Drawing RPC"
  puts 'Drawing RPC Barrel'
  draw_as_front_face(entities, g["RPCBarrel3D_V1"], rpc_material)
  puts 'Drawing RPC Endcaps'
  draw_as_front_face(entities, g["RPCMinusEndcap3D_V1"], rpc_material)
  draw_as_front_face(entities, g["RPCPlusEndcap3D_V1"], rpc_material)
}

dialog.show