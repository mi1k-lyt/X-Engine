#pragma once

#include "XEngine/Core/Core.h"
#include "XEngine/Core/Layer.h"

#include <vector>

namespace XEngine {

	class XENGINE_API LayerStack
	{
	public:
		LayerStack();
		~LayerStack();

		void PushLayer(Layer* layer);
		void PushOverlay(Layer* overlay);
		void PopLayer(Layer* layer);
		void PopOverlay(Layer* overlay);

		std::vector<Layer*>::iterator begin() { return m_Layers.begin(); }
		std::vector<Layer*>::iterator end() { return m_Layers.end(); }

	private:
		// real dataStruct is not stack, because it need iterate on update
		// we need contiguous data storage
		
		// Render Order-->                  <--Event Order
		// (begin,               ...                  ,end)
		std::vector<Layer*> m_Layers;
		std::vector<Layer*>::iterator m_LayerInsert;
	};

}
