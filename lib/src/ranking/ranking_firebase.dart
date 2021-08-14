import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_maths/src/ranking/ranking_save.dart';

class RankingFirebase{

  int max=5;
  RankingSave rankingSave;
  double ave=0;
  int pos=0;
  RankingFirebase(this.rankingSave);

  Future<List<Rank>> getRankings(String op,int level,int typeLast) async {
    ///Gets sorted rankings
    CollectionReference collection = FirebaseFirestore.instance.collection(op+'_L'+level.toString()+'V'+typeLast.toString());

    QuerySnapshot records = await collection.orderBy('ave',descending: false).limitToLast(max).get();

    List<Rank> list = [];
    bool saveNew=true;

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
    ave=newRecord.ave.toDouble();

    Map<String, dynamic> data;
    if (records.docs.length != 0) {
      int pos=0;
      for (var doc in records.docs) {
        pos++;
        data = doc.data()! as Map<String, dynamic>;
        if(newRecord.ave!=-1 && newRecord.ave<=data['ave'] && saveNew && newRecord.position==-1){
          //Set new record and add to database
          newRecord.position=pos;
          this.pos=pos;
          collection.add({'name':newRecord.name,'ave':newRecord.ave});
          pos++;
        }
        if(data['name']==newRecord.name){
          if(newRecord.ave<=data['ave']){
            //Replace old record
            //collection.doc(data['id']);
            doc.reference.delete();
          }else{
            //Maintain old record
            this.pos=pos;
            saveNew=false;
            list.add(Rank(ave: data['ave'],name: data['name'],position: pos));
            list.last.isMain=true;
          }
        }else{
          list.add(Rank(ave: data['ave'],name: data['name'],position: pos));
        }
      }
      if (newRecord.position!=-1){
        list.insert(newRecord.position-1,newRecord);
      }
    }else if(newRecord.ave!=-1 && newRecord.ave!=0){
      newRecord.position=1;
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