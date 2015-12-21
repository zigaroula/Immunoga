package {
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.resource.component.EntityBundle;
	import com.ktm.genome.core.entity.IEntityManager;
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.render.component.Layered;
	import com.ktm.genome.resource.component.TextureResource;
	import com.lip6.genome.geography.move.component.Speed;
	import com.lip6.genome.geography.move.component.TargetPos;

	import components.SystemeImmunitaire.Macrophage;
	import components.SystemeImmunitaire.LymphocyteB;
	import components.SystemeImmunitaire.LymphocyteT;
	import components.SystemeImmunitaire.LymphocyteBBacterien;
	import components.SystemeImmunitaire.LymphocyteBViral;
	import components.SIEntity;
	
	import components.Intrus.Toxine;
	import components.Intrus.Dechet;
	import components.Intrus.Virus;
	
	public class EntityFactory {
		static public function createResourcedEntity(em:IEntityManager, _source:String, _id:String):void {
			// Creation d'une entité vide
			var e:IEntity = em.create();
			// Ajout du composant EntityBundle à cette entité et initialisation de ces trois propriétés : source, id et toBuild
			em.addComponent(e, EntityBundle, { source: _source, id: _id, toBuild: true } );
		}
		
		static public function createEntityXY(em:IEntityManager, _x:int, _y:int ):void {
			var e:IEntity = em.create();
			em.addComponent (e, Transform, {x:_x, y:_y} );
			em.addComponent (e, Layered, { layerId:"gameLayer" } );
			em.addComponent (e, TextureResource, { source:"pictures/macro.png", id:"macrophage" } );
			em.addComponent (e, Speed, { velocity:10 } );
			em.addComponent (e, TargetPos, { x: _x, y:-20 } );
			em.addComponent (e, Macrophage);
		}
		
		static public function createEntityOfType(em:IEntityManager, _x:int, _y:int, _type:int):void {
			var e:IEntity = em.create();
			em.addComponent (e, Transform, {x:_x, y:_y} );
			em.addComponent (e, Layered, { layerId:"gameLayer" } );
			em.addComponent (e, Speed, { velocity:10 } );
			em.addComponent (e, TargetPos, { x: _x, y: -50 } );
			em.addComponent (e, SIEntity, {hp: 100 } );
			switch(_type) {
				case Global.MACROPHAGE:
					em.addComponent (e, TextureResource, { source:"pictures/macro.png", id:"macrophage" } );
					em.addComponent (e, Macrophage, { absorb:10 } );
					break;
				case Global.LYMPHOCYTEB:
					em.addComponent (e, TextureResource, { source:"pictures/bCell.png", id:"lymphocyteb" } );
					em.addComponent (e, LymphocyteB, { } );
					break;
				case Global.LYMPHOCYTET:
					em.addComponent (e, TextureResource, { source:"pictures/tCell.png", id:"lymphocytet" } );
					em.addComponent (e, LymphocyteT, { } );
					break;
				case Global.LYMPHBBACT:
					em.addComponent (e, TextureResource, { source:"pictures/lymphBBact.png", id:"lymphBBact" } );
					em.addComponent (e, LymphocyteBBacterien, { } );
					break;
				case Global.LYMPHBVIR:
					em.addComponent (e, TextureResource, { source:"pictures/lymphBVir.png", id:"lymphBVir" } );
					em.addComponent (e, LymphocyteBViral, { } );
					break;
			}
		}
		
		static public function createToxine(em:IEntityManager, _x:int, _y:int, tarX:int, tarY:int):void {
			var e:IEntity = em.create();
			em.addComponent (e, Transform, {x:_x, y:_y} );
			em.addComponent (e, Layered, { layerId:"gameLayer" } );
			em.addComponent (e, Speed, { velocity:2 } );
			em.addComponent (e, SIEntity, { hp:100 } );
			em.addComponent (e, TargetPos, { x: tarX, y: tarY } );
			em.addComponent (e, TextureResource, { source:"pictures/toxin.png", id:"toxine" } );
			em.addComponent (e, Toxine, { } );
		}
		
		static public function createDechet(em:IEntityManager, _x:int, _y:int, tarX:int, tarY:int, type:int):void {
		
			var e:IEntity = em.create();
			em.addComponent (e, Transform, {x:_x, y:_y} );
			em.addComponent (e, Layered, { layerId:"gameLayer" } );
			em.addComponent (e, Speed, { velocity:0.2 } );
			em.addComponent (e, SIEntity, { hp:100 } );
			em.addComponent (e, TargetPos, { x: tarX, y: tarY } );
			
			switch (type) {
				case 1: em.addComponent (e, TextureResource, { source:"pictures/waste1.png", id:"waste1" } );
					break;
				case 2: em.addComponent (e, TextureResource, { source:"pictures/waste2.png", id:"waste2" } );
					break;
				case 3: em.addComponent (e, TextureResource, { source:"pictures/waste3.png", id:"waste3" } );
					break;
			}
			
			em.addComponent (e, Dechet, { } );
		}
		
		static public function createVirus(em:IEntityManager, _x:int, _y:int, tarX:int, tarY:int):void {
		
			var e:IEntity = em.create();
			em.addComponent (e, Transform, {x:_x, y:_y} );
			em.addComponent (e, Layered, { layerId:"gameLayer" } );
			em.addComponent (e, Speed, { velocity:0.3 } );
			em.addComponent (e, SIEntity, { hp:100 } );
			em.addComponent (e, TargetPos, { x: tarX, y: tarY } );
			em.addComponent (e, TextureResource, { source:"pictures/virus.png", id:"virus" } );
			
			em.addComponent (e, Virus, { } );
		}
	}
}