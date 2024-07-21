//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   21 Jul 2024  Andy Frank  Creation
//

@Js class DxRecTest : AbstractDxTest
{

//////////////////////////////////////////////////////////////////////////
// Basics
//////////////////////////////////////////////////////////////////////////

  Void testBasics()
  {
    r := DxRec(["id":1, "a":12, "b":"foo", "c":false])
    verifyEq(keys(r).size, 4)
    verifyEq(keys(r), ["id", "a","b","c"])
    // get
    verifyEq(r.id, 1)
    verifyEq(r.get("id"), 1)
    verifyEq(r.get("a"),  12)
    verifyEq(r.get("b"),  "foo")
    verifyEq(r.get("c"),  false)
    // trap
    verifyEq(r->id, 1)
    verifyEq(r->a,  12)
    verifyEq(r->b,  "foo")
    verifyEq(r->c,  false)
  }

//////////////////////////////////////////////////////////////////////////
// Merge
//////////////////////////////////////////////////////////////////////////

  Void testMerge()
  {
    r1 := DxRec(["id":1, "a":12, "b":"foo", "c":false])

    // r1 -> [d:55]
    m1 := r1.merge(["d":55])
    verifyRec(m1, ["id":1, "a":12, "b":"foo", "c":false, "d":55])

    // r1 -> [id:(skip) a:diff_type d:56]
    m2 := r1.merge(["id":4, "a":"diff_type", "d":56])
    verifyRec(m2, ["id":1, "a":"diff_type", "b":"foo", "c":false, "d":56])

    // r1 -> [a:(remove)]
    m3 := r1.merge(["a":null])
    verifyRec(m3, ["id":1, "b":"foo", "c":false])
  }

//////////////////////////////////////////////////////////////////////////
// Support
//////////////////////////////////////////////////////////////////////////

  private Str[] keys(DxRec rec)
  {
    acc := Str[,]
    rec.each |v,k| { acc.add(k) }
    acc.moveTo("id", 0)
    return acc
  }
}