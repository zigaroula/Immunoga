package {
	import com.ktm.genome.core.entity.IEntity;
	import com.ktm.genome.resource.component.EntityBundle;
	import com.ktm.genome.core.entity.IEntityManager;
	
	import com.ktm.genome.render.component.Transform;
	import com.ktm.genome.render.component.Layered;
	import com.ktm.genome.resource.component.TextureResource;
	import com.lip6.genome.geography.move.component.Speed;
	import com.lip6.genome.geography.move.component.TargetPos;
	//import components.Ship;
	
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
			em.addComponent (e, TargetPos, { x: _x, y:0 } );
		}
	}
}