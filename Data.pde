//j2towers  //<>// //<>// //<>// //<>//
//20594656

//object stuff
String next;
JSONObject page;
ArrayList<Product> products;

//p5 stuff
import controlP5.*;
ControlP5 ui;
Textfield field;
RadioButton type;
boolean searching = false;

//counts item currently showing
int counter = 0;

//how much spend & while limiter
int budg;
int cur = 0;

//filters
boolean beer = false;
boolean wine = false;
boolean spirits = false;

//turning displays on and off
boolean first = true;
boolean rendered = false;

PFont fnt;

void setup() {
  size(600, 600);

  //products array
  products = new ArrayList<Product>();

  //load JSONObject from URL
  page = loadJSONObject(
    "https://lcboapi.com/products?per_page=100&store_id=115&where_not=is_dead,is_discontinued&order=price_in_cents.asc&access_key=MDowYjViNWM4Yy1mODdiLTExZTUtOWM3Ni1lMzhhNzY4ZDllZjM6OTJNRHFBZHY3bmhKS0lXOGZwOVA1bWM5TGJTTU9VVnlTZ0Qy");

  //control p5

  fnt = createFont( "Helvetica", 20 );
  ui = new ControlP5( this );
  field = ui.addTextfield( "What's your budget?" )
    .setPosition( 5, 5 )
    .setSize( 290, 25 )
    .setAutoClear( false )
    .setFont( fnt );

  type = ui.addRadio( "Type" )
    .setPosition( width/2 + 5, 5 )
    .setSize( 10, 10 )
    .addItem( "Beer", 1 )
    .addItem("Wine", 2)
    .addItem("Spirits", 3)
    .addItem("Everything", 4)
    .setValue(4);
}


void draw() {
  background(255);

  //show instructions
  if (first) {
    textAlign(CENTER);
    text("Enter your LCBO budget and use left or right arrows to browse your options at the Uptown location", width/2, height/2);
    textAlign(LEFT);
  }

  fill(100);
  noStroke();
  rect(3, 3, 380, 47);


  //walk over result
  if (searching) {
    JSONArray arr = page.getJSONArray("result");
    
    //debugging stuff
    //println(wine);
    //println(beer);
    //println(spirits);

    //while loop to check if current price is at or below your budget
    while (cur <= (budg * 100)) {
      arr = page.getJSONArray("result");

      //add products to product array and remember current price
      for (int j = 0; j < arr.size(); j++) {
        if (beer) {
          if (arr.getJSONObject(j).getInt("price_in_cents") <= (budg * 100) && 
            arr.getJSONObject(j).getInt("alcohol_content") > 0 && 
            arr.getJSONObject(j).getString("primary_category").equals("Beer")) {
            products.add(new Product(arr.getJSONObject(j)));
            int k;
            if (j == arr.size() - 1) {
              k = 0;
            } else {
              k = j + 1;
            }
            cur = arr.getJSONObject(k).getInt("price_in_cents");
          }
        } else if (wine) {
          if (arr.getJSONObject(j).getInt("price_in_cents") <= (budg * 100) && 
            arr.getJSONObject(j).getInt("alcohol_content") > 0 && 
            arr.getJSONObject(j).getString("primary_category").equals("Wine")) {
            products.add(new Product(arr.getJSONObject(j)));
            int k;
            if (j == arr.size() - 1) {
              k = 0;
            } else {
              k = j + 1;
            }
            cur = arr.getJSONObject(k).getInt("price_in_cents");
          }
        } else if (spirits) {
          if (arr.getJSONObject(j).getInt("price_in_cents") <= (budg * 100) && 
            arr.getJSONObject(j).getInt("alcohol_content") > 0 && 
            arr.getJSONObject(j).getString("primary_category").equals("Spirits")) {
            products.add(new Product(arr.getJSONObject(j)));
            int k;
            if (j == arr.size() - 1) {
              k = 0;
            } else {
              k = j + 1;
            }
            cur = arr.getJSONObject(k).getInt("price_in_cents");
          }
        } else {
          if (arr.getJSONObject(j).getInt("price_in_cents") <= (budg * 100) && 
            arr.getJSONObject(j).getInt("alcohol_content") > 0) {
            //debugging code
            //println(arr.getJSONObject(j).getInt("id"));
            //Product p = new Product(arr.getJSONObject(j));
            //if (!products.contains(p)) {
            products.add(new Product(arr.getJSONObject(j)));
            int k;
            if (j == arr.size() - 1) {
              k = 0;
            } else {
              k = j + 1;
            }
            cur = arr.getJSONObject(k).getInt("price_in_cents");
          }
          //}
        }
      }

      //what page am i on
      println(page.getJSONObject("pager").getInt("current_page"));
      //debugging code
      /* println(cur);
       println(arr.getJSONObject(arr.size() - 1).getInt("price_in_cents"));
       println(products.length);
       println(page.getJSONObject("pager").getInt("current_page"));
       println(page.getJSONObject("pager").getInt("next_page"));*/

      //check whether or not to load the next page of products from the API
      if (arr.getJSONObject(arr.size()-1).getInt("price_in_cents") < (budg * 100)) {
        if (page.getJSONObject("pager").getString("next_page_path") != null) { //change to isNull
          next = "https://lcboapi.com" + page.getJSONObject("pager").getString("next_page_path");
        }
        page = loadJSONObject(next);
        //does the guy who runs this API hat me
        println("called");
      } else {
        break;
      }
    }
  }

  //remove dupes
  for (int i = products.size() - 1; i >= 0; i--) {
    int count = 0;
    Product p = products.get(i);
    for (int j = 0; j < products.size(); j++) {
      Product q = products.get(j);
      if (p.name.equals(q.name)) {
        count++;
      }
    }
    if (count > 1) {
      products.remove(i);
    }
  }


  //render products 
  if (products.size() > 0) {
    if (products.get(counter).nopic == false) {
      if (!keyPressed) {
        textAlign(CENTER);      
        text("Press spacebar to see " + products.get(counter).type.toLowerCase(), width/2, height/2 + 130);
        textAlign(LEFT);
      }
    } else {
      textAlign(CENTER); 
      text("No image available", width/2, height/2 + 130);
      textAlign(LEFT);
    }

    products.get(counter).render();
    rendered = true;
  }

  //total options
  if (rendered) {
    text( "Returned " + products.size() + " Options", 5, height - 10);
  }

  searching = false;
}

//grab the budget and turn on and off booleans
void controlEvent( ControlEvent ce )
{
  //hide instructions
  first = false;

  //trim array if the budget or filter changes
  if (int(field.getText()) < budg) {
    budg = int(field.getText());
    for (int i = products.size() - 1; i >= 0; i--) {
      Product p = products.get(i);
      println(p.priceint);
      println(budg * 100);
      if (p.priceint > (budg * 100)) {
        products.remove(i);
      }
    }
  } else {
    budg = int(field.getText());
    searching = true;
    page = loadJSONObject(
      "https://lcboapi.com/products?per_page=100&store_id=115&where_not=is_dead,is_discontinued&order=price_in_cents.asc&access_key=MDowYjViNWM4Yy1mODdiLTExZTUtOWM3Ni1lMzhhNzY4ZDllZjM6OTJNRHFBZHY3bmhKS0lXOGZwOVA1bWM5TGJTTU9VVnlTZ0Qy&page=1");
  }

  if ( ce.isFrom( type ) ) {
    if ( ce.getValue() == 1 ) {
      if (wine || spirits) {
        cur = 0;
      }
      beer = true;
      wine = false;
      spirits = false;
      counter = 0;
      for (int i = products.size() - 1; i >= 0; i--) {
        Product p = products.get(i);
        if (!p.type.equals("Beer")) {
          println(products.get(i).type);
          products.remove(i);
        }
      }
    } else if (ce.getValue() == 2) {
      if (beer || spirits) {
        cur = 0;
      }
      beer = false;
      wine = true;
      spirits = false;
      counter = 0;
      for (int i = products.size() - 1; i >= 0; i--) {
        Product p = products.get(i);
        if (!p.type.equals("Wine")) {
          println(products.get(i).type);
          products.remove(i);
        }
      }
    } else if (ce.getValue() == 3) {
            if(wine || beer){
        cur = 0;
      }
      beer = false;
      wine = false;
      spirits = true;
      counter = 0;
      for (int i = products.size() - 1; i >= 0; i--) {
        Product p = products.get(i);
        if (!p.type.equals("Spirits")) {
          println(products.get(i).type);
          products.remove(i);
        }
      }
    } else if (ce.getValue() == 4) {
            if(wine || spirits || beer){
        cur = 0;
      }
      beer = false;
      wine = false;
      spirits = false;
      budg = int(field.getText());
    }
  }
  searching = true;
  counter = 0;
}


//let user scroll through index of products
void keyPressed() {
  if (key ==  CODED) {
    if (keyCode == RIGHT) {
      if (counter == products.size() - 1) {
        counter = 0;
      } else {
        counter++;
      }
    }
    if (keyCode == LEFT) {
      if (counter == 0) {
        counter = products.size() - 1;
      } else {
        counter--;
      }
    }
  }
  //debugging 
  //if (key == 'p') {
  //  budg = 100;
  //  searching = true;
  //}
}