unit uConstant;

interface

//Статус гусеницы: жива, подбита, мертва
type
    TLiveStatus = (stLive, stHit, stReadyForDestroy, stGameOver);

//Выбор направления движения гусениц
type
    TMoveDirection = (directionLeft, directionRight);


//Выбор направления стены
type
    TBrickDirection = (directionBrickLeft, directionBrickRight);

type
     TWeaponType = (wtPssst, wtLight);

implementation

Uses UWorms, UFlyes, UBrick;

end.
