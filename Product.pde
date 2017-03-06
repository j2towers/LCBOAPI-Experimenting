//class that represents a single product. adapted from twitter sketch //<>//

class Product
{
  String name;
  String price;
  int priceint;
  String type;
  String serving_suggestion;
  String tasting_notes;
  String size;
  boolean nopic = true;
  PImage pic;
  
  JSONObject obje;

  // The constructor expects you to pass in a JSONObject 
  Product( JSONObject obj )
  {

    //check for null and load product info and pictures
    name = obj.getString( "name" );
    price = ("$" + obj.getFloat("price_in_cents") / 100);
    priceint = obj.getInt("price_in_cents");
    type = obj.getString("primary_category");
    size = (obj.getFloat("volume_in_milliliters") + "ml");
    if (!obj.isNull( "image_url" )) {
      nopic = false;
    }
    if (!obj.isNull("serving_suggestion")) {
      serving_suggestion = obj.getString("serving_suggestion");
    } else {
      serving_suggestion = " ";
    }
    if (!obj.isNull("tasting_note")) {
      tasting_notes = obj.getString("tasting_note");
    } else {
      tasting_notes = " ";
    }
    //memory problems killed autoloading images 
    //if (!obj.isNull( "image_url" )) {
    //String url = obj.getString( "image_thumb_url" );
    //pic = loadImage( url );
    //}
    obje = obj;
  }

  void render()
  {
    //picture load tied to event due to memory constraints
    if (keyPressed) {
     if (key == ' ') {
       if (!obje.isNull( "image_url" )) {
         String url = obje.getString( "image_thumb_url" );
         pic = loadImage( url );
       }
       imageMode(CENTER);
       if ( pic != null ) {
         image( pic, width/2, height/2 + 130, pic.width * .8, pic.height * .8);
       }
     }
    }
    fill(0);
    textFont(fnt);
    textSize(20);
    text( "Name: " + name, 5, 70 );
    text( "Price: " + price, 5, 95);
    text( "Size: " + size, 5, 120);
    textSize(15);
    text( "Serving Suggestion: " + serving_suggestion, 5, 140, width - 5, 50);
    text( "Tasting Notes: " + tasting_notes, 5, 190, width - 5, 90 );
  }
}