import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_maths/src/ranking/ranking_save.dart';

import '../config.dart';

class RankingFirebase{

  int max=50;
  RankingSave rankingSave;
  double ave=0;
  int pos=0;
  DatabaseCache dtCache;
  bool _enableNextCounter=true;
  int _cacheDuration=120;

  RankingFirebase(this.rankingSave,this.dtCache);

  Future<List<Rank>> getRankings(String op,int level,int typeLast) async {
    ///Gets sorted rankings
    CollectionReference collection = FirebaseFirestore.instance.collection(op+'_L'+level.toString()+'V'+typeLast.toString());

    //Get documents from cache or online
    QuerySnapshot records;
    print(dtCache.fromCache(op, level, typeLast));
    if(dtCache.fromCache(op, level, typeLast)){
      print('from cache');
      records = await collection.orderBy('ave',descending: false).limitToLast(max+2).get(GetOptions(source: Source.cache));
    }else{
      print('from database');
      records = await collection.orderBy('ave',descending: false).limitToLast(max+2).get();
      dtCache.enableFromCache(op, level, typeLast);
      if(_enableNextCounter){
        Future.delayed(Duration(seconds: _cacheDuration),(){
          print('cache disable');
          dtCache.disableFromCache(op, level, typeLast);
          _enableNextCounter=true;
        });
        _enableNextCounter=false;
      }
    }

    List<Rank> list = [];
    bool saveNew=true;

    //Get actual record
    Rank newRecord = new Rank(position: -1, ave: -1, name: 'Unset');
    if(op=='addition'){
      if(typeLast==1)
        newRecord=Rank(position: -1, ave: rankingSave.additionL1[level], name: rankingSave.name);
      if(typeLast==2)
        newRecord=Rank(position: -1, ave: rankingSave.additionL2[level], name: rankingSave.name);
    }
    else{
      if(typeLast==1)
        newRecord=Rank(position: -1, ave: rankingSave.subtractionL1[level], name: rankingSave.name);
      if(typeLast==2)
        newRecord=Rank(position: -1, ave: rankingSave.subtractionL1[level], name: rankingSave.name);
    }

    newRecord.isMain=true;
    if(newRecord.ave==-1 || newRecord.ave==0)
      saveNew=false;
    ave=newRecord.ave.toDouble();

    //Read all records
    Map<String, dynamic> data;
    if (records.docs.length != 0) {
      int pos=0;
      for (var doc in records.docs) {
        pos++;
        data = doc.data()! as Map<String, dynamic>;
        if(newRecord.ave<=data['ave'] && saveNew){
          //Insert new record and add to database
          newRecord.position=pos;
          this.pos=pos;
          collection.add({'name':newRecord.name,'ave':newRecord.ave});
          list.add(newRecord);
          pos++;
          saveNew=false;
        }
        if(data['name']==newRecord.name){
          if(newRecord.ave<=data['ave'] &&(newRecord.ave!=0 && newRecord.ave!=-1)){
            //Replace old record
            pos--;
            doc.reference.delete();
          }else{
            //Maintain old record
            this.pos=pos;
            saveNew=false;
            list.add(Rank(ave: data['ave'],name: data['name'],position: pos));
            list.last.isMain=true;
          }
        }else{
          //Add record to list
          list.add(Rank(ave: data['ave'],name: data['name'],position: pos));
        }
      }
      if(records.docs.length<max && saveNew && newRecord.position==-1){
        //Set new record at last
        newRecord.position=pos;
        this.pos=pos;
        collection.add({'name':newRecord.name,'ave':newRecord.ave});
        list.add(newRecord);
      }else if(records.docs.length>=max){
        //Deleting las record
        collection.doc(records.docs.last.id).delete();
      }
    }else if(saveNew){
      //Setting first new record
      newRecord.position=pos;
      this.pos=newRecord.position;
      collection.add({'name':newRecord.name,'ave':newRecord.ave});
      list.add(newRecord);
    }

    return list;
  }

}

class Rank{
  int position;
  num ave;
  String name;
  bool isMain=false;
  Rank({required this.position,required this.ave,required this.name});
}